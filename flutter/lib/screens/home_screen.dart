import 'package:flutter/material.dart';
import '../services/rebrickable_api.dart';
import '../services/rebrickable_exceptions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _apiStatus = 'Checking API connection...';

  final List<Widget> _pages = [
    const HomeTab(),
    const GalleryTab(),
    const SlideshowTab(),
  ];

  @override
  void initState() {
    super.initState();
    _testApiConnection();
  }

  Future<void> _testApiConnection() async {
    try {
      final apiClient = RebrickableApi.getInstance();
      final result = await apiClient.getThemes(page: 1, pageSize: 5);
      
      setState(() {
        _apiStatus = 'API Connected - ${result.count} themes available';
      });
    } on AuthenticationException {
      setState(() {
        _apiStatus = 'API Key Required - Please configure REBRICKABLE_API_KEY';
      });
    } on NetworkException {
      setState(() {
        _apiStatus = 'Network Error - Check internet connection';
      });
    } catch (e) {
      setState(() {
        _apiStatus = 'API Error - ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brixie'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Brixie',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.slideshow),
              title: const Text('Slideshow'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Replace with your own action'),
            ),
          );
        },
        tooltip: 'Action',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is home Fragment',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ApiStatusWidget(),
          ],
        ),
      ),
    );
  }
}

class ApiStatusWidget extends StatefulWidget {
  const ApiStatusWidget({super.key});

  @override
  State<ApiStatusWidget> createState() => _ApiStatusWidgetState();
}

class _ApiStatusWidgetState extends State<ApiStatusWidget> {
  String _apiStatus = 'Checking API connection...';

  @override
  void initState() {
    super.initState();
    _testApiConnection();
  }

  Future<void> _testApiConnection() async {
    try {
      final apiClient = RebrickableApi.getInstance();
      final result = await apiClient.getThemes(page: 1, pageSize: 5);
      
      setState(() {
        _apiStatus = 'API Connected - ${result.count} themes available\n\nFirst 3 themes:\n';
        for (int i = 0; i < result.results.length && i < 3; i++) {
          final theme = result.results[i];
          _apiStatus += '  - ${theme.name} (ID: ${theme.id})\n';
        }
      });
    } on AuthenticationException {
      setState(() {
        _apiStatus = 'API Key Required - Please configure REBRICKABLE_API_KEY';
      });
    } on NetworkException {
      setState(() {
        _apiStatus = 'Network Error - Check internet connection';
      });
    } catch (e) {
      setState(() {
        _apiStatus = 'API Error - ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Rebrickable API Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_apiStatus),
          ],
        ),
      ),
    );
  }
}

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is gallery Fragment',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class SlideshowTab extends StatelessWidget {
  const SlideshowTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is slideshow Fragment',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}