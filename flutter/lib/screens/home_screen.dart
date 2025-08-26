import 'package:flutter/material.dart';
import '../services/rebrickable_api.dart';
import '../services/rebrickable_exceptions.dart';
import 'sets_screen.dart';
import 'parts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const SetsScreen(),
    const PartsScreen(),
    const SlideshowTab(),
  ];

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.extension,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Brixie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'LEGO Set Browser',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
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
              leading: const Icon(Icons.extension),
              title: const Text('LEGO Sets'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('LEGO Parts'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 1 || _selectedIndex == 2 ? null : FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 0) {
            // Navigate to Sets screen
            setState(() {
              _selectedIndex = 1;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Replace with your own action'),
              ),
            );
          }
        },
        tooltip: _selectedIndex == 0 ? 'Browse Sets' : 'Action',
        child: Icon(_selectedIndex == 0 ? Icons.search : Icons.add),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.extension, color: Colors.red[700], size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Welcome to Brixie',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your LEGO set and parts browser powered by Rebrickable.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SetsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.extension),
                          label: const Text('Browse Sets'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PartsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.category),
                          label: const Text('Browse Parts'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const ApiStatusWidget(),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    Icons.search,
                    'Search Sets',
                    'Find LEGO sets by name, theme, or year',
                  ),
                  _buildFeatureTile(
                    Icons.info_outline,
                    'Set Details',
                    'View comprehensive information about each set',
                  ),
                  _buildFeatureTile(
                    Icons.extension,
                    'Parts Database',
                    'Explore individual LEGO parts and pieces',
                  ),
                  _buildFeatureTile(
                    Icons.palette,
                    'Colors & Themes',
                    'Browse by LEGO themes and color variations',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.red[700]),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
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



class SlideshowTab extends StatelessWidget {
  const SlideshowTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Brixie',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brixie is a Flutter application for browsing LEGO sets and parts using the Rebrickable API.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Features:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• Cross-platform iOS and Android support'),
                  Text('• Search and browse LEGO sets'),
                  Text('• View detailed set information'),
                  Text('• Material Design interface'),
                  Text('• Offline capability'),
                  SizedBox(height: 12),
                  Text(
                    'Powered by Rebrickable API',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Version Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text('Version: 1.0.0'),
                  const Text('Flutter: Cross-platform'),
                  const Text('License: AGPL-3.0'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}