import 'package:flutter/material.dart';
import '../models/lego_models.dart';
import '../services/rebrickable_api.dart';
import '../services/rebrickable_exceptions.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({super.key});

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<LegoPart> _parts = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadParts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreParts();
      }
    }
  }

  Future<void> _loadParts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
      _parts.clear();
    });

    await _fetchParts();
  }

  Future<void> _loadMoreParts() async {
    if (_isLoading || !_hasMoreData) return;
    
    setState(() {
      _isLoading = true;
    });

    _currentPage++;
    await _fetchParts();
  }

  Future<void> _fetchParts() async {
    try {
      final apiClient = RebrickableApi.getInstance();
      final result = await apiClient.getParts(
        search: _searchController.text.isEmpty ? null : _searchController.text,
        page: _currentPage,
        pageSize: 20,
      );

      setState(() {
        if (_currentPage == 1) {
          _parts = result.results;
        } else {
          _parts.addAll(result.results);
        }
        _hasMoreData = result.next != null;
        _isLoading = false;
        _hasError = false;
      });
    } on AuthenticationException catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Authentication Error: ${e.message}';
      });
    } on NetworkException catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Network Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEGO Parts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search parts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadParts();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (_) => _loadParts(),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadParts,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError && _parts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadParts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_parts.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_parts.isEmpty) {
      return const Center(
        child: Text(
          'No parts found.\nTry a different search term.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _parts.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _parts.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final part = _parts[index];
        return PartCard(part: part);
      },
    );
  }
}

class PartCard extends StatelessWidget {
  final LegoPart part;

  const PartCard({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: part.partImgUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  part.partImgUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.category),
                ),
              )
            : const Icon(Icons.category, size: 50),
        title: Text(
          part.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Part ${part.partNum}'),
            Text('Category: ${part.partCatId}'),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartDetailScreen(partNum: part.partNum),
            ),
          );
        },
      ),
    );
  }
}

class PartDetailScreen extends StatefulWidget {
  final String partNum;

  const PartDetailScreen({super.key, required this.partNum});

  @override
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen> {
  LegoPart? _part;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPartDetails();
  }

  Future<void> _loadPartDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = RebrickableApi.getInstance();
      final part = await apiClient.getPart(widget.partNum);
      
      setState(() {
        _part = part;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_part?.name ?? 'Part Details'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPartDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_part == null) {
      return const Center(child: Text('Part not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_part!.partImgUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _part!.partImgUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.category, size: 200),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            _part!.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Part ${_part!.partNum}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Category ID', _part!.partCatId.toString()),
          if (_part!.printOf != null)
            _buildDetailRow('Print Of', _part!.printOf!),
          if (_part!.externalIds != null) ...[
            const SizedBox(height: 8),
            Text(
              'External IDs:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ..._part!.externalIds!.entries.map(
              (entry) => _buildDetailRow(entry.key, entry.value.join(', ')),
            ),
          ],
          if (_part!.partUrl != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // In a real app, you'd open the URL
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View on Rebrickable')),
                );
              },
              child: const Text('View on Rebrickable'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}