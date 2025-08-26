/// Base class for all Rebrickable API exceptions
abstract class RebrickableException implements Exception {
  final String message;
  final Exception? originalException;

  const RebrickableException(this.message, [this.originalException]);

  @override
  String toString() => 'RebrickableException: $message';
}

/// Authentication failed - invalid or missing API key
class AuthenticationException extends RebrickableException {
  const AuthenticationException(String message, [Exception? originalException])
      : super(message, originalException);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Network connectivity issues
class NetworkException extends RebrickableException {
  const NetworkException(String message, [Exception? originalException])
      : super(message, originalException);

  @override
  String toString() => 'NetworkException: $message';
}

/// API rate limit exceeded
class RateLimitException extends RebrickableException {
  const RateLimitException(String message, [Exception? originalException])
      : super(message, originalException);

  @override
  String toString() => 'RateLimitException: $message';
}

/// Requested resource not found
class NotFoundException extends RebrickableException {
  const NotFoundException(String message, [Exception? originalException])
      : super(message, originalException);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Server-side errors (5xx status codes)
class ServerException extends RebrickableException {
  const ServerException(String message, [Exception? originalException])
      : super(message, originalException);

  @override
  String toString() => 'ServerException: $message';
}

/// Generic API errors not covered by specific exceptions
class ApiException extends RebrickableException {
  final int? statusCode;

  const ApiException(String message, [this.statusCode, Exception? originalException])
      : super(message, originalException);

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}