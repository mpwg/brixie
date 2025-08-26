import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic paginated response wrapper for Rebrickable API
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  ApiResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

/// API Error response model
@JsonSerializable()
class ApiError {
  final String? detail;
  final Map<String, dynamic>? errors;

  ApiError({this.detail, this.errors});

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}