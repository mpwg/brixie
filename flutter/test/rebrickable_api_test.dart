import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:brixie/services/rebrickable_api_client_impl.dart';
import 'package:brixie/services/rebrickable_exceptions.dart';

import 'rebrickable_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('RebrickableApiClient Tests', () {
    late MockClient mockHttpClient;
    late RebrickableApiClientImpl apiClient;

    setUp(() {
      mockHttpClient = MockClient();
      apiClient = RebrickableApiClientImpl(
        apiKey: 'test_api_key',
        httpClient: mockHttpClient,
      );
    });

    tearDown(() {
      apiClient.dispose();
    });

    test('getThemes returns valid response', () async {
      // Mock response
      const responseBody = '''
      {
        "count": 2,
        "next": null,
        "previous": null,
        "results": [
          {"id": 1, "name": "Technic", "parent_id": null},
          {"id": 2, "name": "City", "parent_id": null}
        ]
      }
      ''';

      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(responseBody, 200));

      // Test
      final result = await apiClient.getThemes();

      // Verify
      expect(result.count, 2);
      expect(result.results.length, 2);
      expect(result.results[0].name, 'Technic');
      expect(result.results[1].name, 'City');
    });

    test('authentication exception on 401', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('{"detail": "Invalid API key"}', 401));

      expect(() => apiClient.getThemes(), throwsA(isA<AuthenticationException>()));
    });

    test('network exception on socket error', () async {
      when(mockHttpClient.get(any))
          .thenThrow(const SocketException('Network error'));

      expect(() => apiClient.getThemes(), throwsA(isA<NetworkException>()));
    });
  });
}