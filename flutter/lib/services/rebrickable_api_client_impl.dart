import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/lego_models.dart';
import 'rebrickable_api_client.dart';
import 'rebrickable_exceptions.dart';

/// Implementation of RebrickableApiClient using HTTP package
class RebrickableApiClientImpl implements RebrickableApiClient {
  static const String _baseUrl = 'https://rebrickable.com/api/v3/lego/';
  static const int _maxPageSize = 1000;

  final String _apiKey;
  final http.Client _httpClient;

  RebrickableApiClientImpl({
    required String apiKey,
    http.Client? httpClient,
  })  : _apiKey = apiKey,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<ApiResponse<LegoSet>> getSets({
    String? search,
    int page = 1,
    int pageSize = 20,
    int? themeId,
    int? minYear,
    int? maxYear,
    int? minParts,
    int? maxParts,
  }) async {
    final params = <String, String>{
      'key': _apiKey,
      'page': page.toString(),
      'page_size': pageSize.clamp(1, _maxPageSize).toString(),
    };

    if (search != null) params['search'] = search;
    if (themeId != null) params['theme_id'] = themeId.toString();
    if (minYear != null) params['min_year'] = minYear.toString();
    if (maxYear != null) params['max_year'] = maxYear.toString();
    if (minParts != null) params['min_parts'] = minParts.toString();
    if (maxParts != null) params['max_parts'] = maxParts.toString();

    final uri = Uri.parse('${_baseUrl}sets/').replace(queryParameters: params);
    final response = await _makeRequest(uri);
    
    return ApiResponse.fromJson(
      response,
      (json) => LegoSet.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<LegoSet> getSet(String setNum) async {
    final uri = Uri.parse('${_baseUrl}sets/$setNum/').replace(
      queryParameters: {'key': _apiKey},
    );
    final response = await _makeRequest(uri);
    return LegoSet.fromJson(response);
  }

  @override
  Future<ApiResponse<LegoPart>> getParts({
    String? search,
    int page = 1,
    int pageSize = 20,
    int? catId,
  }) async {
    final params = <String, String>{
      'key': _apiKey,
      'page': page.toString(),
      'page_size': pageSize.clamp(1, _maxPageSize).toString(),
    };

    if (search != null) params['search'] = search;
    if (catId != null) params['part_cat_id'] = catId.toString();

    final uri = Uri.parse('${_baseUrl}parts/').replace(queryParameters: params);
    final response = await _makeRequest(uri);
    
    return ApiResponse.fromJson(
      response,
      (json) => LegoPart.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<LegoPart> getPart(String partNum) async {
    final uri = Uri.parse('${_baseUrl}parts/$partNum/').replace(
      queryParameters: {'key': _apiKey},
    );
    final response = await _makeRequest(uri);
    return LegoPart.fromJson(response);
  }

  @override
  Future<ApiResponse<LegoTheme>> getThemes({
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, String>{
      'key': _apiKey,
      'page': page.toString(),
      'page_size': pageSize.clamp(1, _maxPageSize).toString(),
    };

    final uri = Uri.parse('${_baseUrl}themes/').replace(queryParameters: params);
    final response = await _makeRequest(uri);
    
    return ApiResponse.fromJson(
      response,
      (json) => LegoTheme.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<LegoColor>> getColors({
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, String>{
      'key': _apiKey,
      'page': page.toString(),
      'page_size': pageSize.clamp(1, _maxPageSize).toString(),
    };

    final uri = Uri.parse('${_baseUrl}colors/').replace(queryParameters: params);
    final response = await _makeRequest(uri);
    
    return ApiResponse.fromJson(
      response,
      (json) => LegoColor.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Make HTTP request and handle common errors
  Future<Map<String, dynamic>> _makeRequest(Uri uri) async {
    try {
      final response = await _httpClient.get(uri);
      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}', e);
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}', e);
    } catch (e) {
      throw NetworkException('Unknown network error: ${e.toString()}', Exception(e.toString()));
    }
  }

  /// Handle HTTP response and parse JSON
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      
      if (statusCode >= 200 && statusCode < 300) {
        return jsonData;
      }
      
      // Handle error responses
      final error = ApiError.fromJson(jsonData);
      final message = error.detail ?? 'API error occurred';
      
      switch (statusCode) {
        case 401:
          throw AuthenticationException('Invalid API key: $message');
        case 403:
          throw AuthenticationException('Access forbidden: $message');
        case 404:
          throw NotFoundException('Resource not found: $message');
        case 429:
          throw RateLimitException('Rate limit exceeded: $message');
        case >= 500:
          throw ServerException('Server error: $message');
        default:
          throw ApiException('API error: $message', statusCode);
      }
    } on FormatException catch (e) {
      throw ApiException('Invalid JSON response: ${e.message}', statusCode, e);
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}