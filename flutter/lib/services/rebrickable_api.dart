import 'rebrickable_api_client.dart';
import 'rebrickable_api_client_impl.dart';

/// Factory for creating Rebrickable API client instances
class RebrickableApi {
  static RebrickableApiClient? _instance;

  /// Get singleton instance of RebrickableApiClient
  /// Uses environment variable REBRICKABLE_API_KEY or default key
  static RebrickableApiClient getInstance() {
    return _instance ??= RebrickableApiClientImpl(
      apiKey: const String.fromEnvironment(
        'REBRICKABLE_API_KEY',
        defaultValue: 'your_api_key_here',
      ),
    );
  }

  /// Create a new instance with custom API key
  static RebrickableApiClient createInstance(String apiKey) {
    return RebrickableApiClientImpl(apiKey: apiKey);
  }

  /// Reset singleton instance (useful for testing)
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}