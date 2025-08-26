import 'package:flutter/material.dart';
import '../models/lego_models.dart';
import '../models/api_response.dart';
import '../services/rebrickable_api.dart';
import '../services/rebrickable_exceptions.dart';

class SetsScreen extends StatefulWidget {
  const SetsScreen({super.key});

  @override
  State<SetsScreen> createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<LegoSet> _sets = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadSets();
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
        _loadMoreSets();
      }
    }
  }

  Future<void> _loadSets() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
      _sets.clear();
    });

    await _fetchSets();
  }

  Future<void> _loadMoreSets() async {
    if (_isLoading || !_hasMoreData) return;
    
    setState(() {
      _isLoading = true;
    });

    _currentPage++;
    await _fetchSets();
  }

  Future<void> _fetchSets() async {
    try {
      final apiClient = RebrickableApi.getInstance();
      final result = await apiClient.getSets(
        search: _searchController.text.isEmpty ? null : _searchController.text,
        page: _currentPage,
        pageSize: 20,
      );

      setState(() {
        if (_currentPage == 1) {
          _sets = result.results;
        } else {
          _sets.addAll(result.results);
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
        title: const Text('LEGO Sets'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search sets...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadSets();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (_) => _loadSets(),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadSets,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError && _sets.isEmpty) {
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
              onPressed: _loadSets,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_sets.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_sets.isEmpty) {
      return const Center(
        child: Text(
          'No sets found.\nTry a different search term.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _sets.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _sets.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final set = _sets[index];
        return SetCard(set: set);
      },
    );
  }
}

class SetCard extends StatelessWidget {
  final LegoSet set;

  const SetCard({super.key, required this.set});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: set.setImgUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  set.setImgUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              )
            : const Icon(Icons.extension, size: 50),
        title: Text(
          set.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Set ${set.setNum} • ${set.year}'),
            Text('${set.numParts} parts'),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetDetailScreen(setNum: set.setNum),
            ),
          );
        },
      ),
    );
  }
}

class SetDetailScreen extends StatefulWidget {
  final String setNum;

  const SetDetailScreen({super.key, required this.setNum});

  @override
  State<SetDetailScreen> createState() => _SetDetailScreenState();
}

class _SetDetailScreenState extends State<SetDetailScreen> {
  LegoSet? _set;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSetDetails();
  }

  Future<void> _loadSetDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiClient = RebrickableApi.getInstance();
      final set = await apiClient.getSet(widget.setNum);
      
      setState(() {
        _set = set;
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
        title: Text(_set?.name ?? 'Set Details'),
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
              onPressed: _loadSetDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_set == null) {
      return const Center(child: Text('Set not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_set!.setImgUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _set!.setImgUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 200),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            _set!.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Set ${_set!.setNum}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Year', _set!.year.toString()),
          _buildDetailRow('Parts', '${_set!.numParts} pieces'),
          _buildDetailRow('Theme ID', _set!.themeId.toString()),
          if (_set!.setUrl != null) ...[
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
            width: 80,
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