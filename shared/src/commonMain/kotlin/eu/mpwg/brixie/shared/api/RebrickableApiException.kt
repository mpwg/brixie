package eu.mpwg.brixie.shared.api

/**
 * Base class for all Rebrickable API exceptions
 */
open class RebrickableApiException(
    message: String,
    cause: Throwable? = null
) : Exception(message, cause)

/**
 * Thrown when there's a network-related error
 */
class NetworkException(
    message: String = "Network error occurred",
    cause: Throwable? = null
) : RebrickableApiException(message, cause)

/**
 * Thrown when the API key is invalid or missing
 */
class AuthenticationException(
    message: String = "Authentication failed - invalid or missing API key",
    cause: Throwable? = null
) : RebrickableApiException(message, cause)

/**
 * Thrown when the requested resource is not found
 */
class NotFoundException(
    message: String = "Resource not found",
    cause: Throwable? = null
) : RebrickableApiException(message, cause)

/**
 * Thrown when the request is malformed or invalid
 */
class BadRequestException(
    message: String = "Bad request",
    cause: Throwable? = null
) : RebrickableApiException(message, cause)

/**
 * Thrown when rate limit is exceeded
 */
class RateLimitException(
    message: String = "Rate limit exceeded",
    cause: Throwable? = null
) : RebrickableApiException(message, cause)

/**
 * Thrown when there's a server error
 */
class ServerException(
    message: String = "Server error occurred",
    cause: Throwable? = null
) : RebrickableApiException(message, cause)

/**
 * Thrown when the response cannot be parsed
 */
class ParseException(
    message: String = "Failed to parse API response",
    cause: Throwable? = null
) : RebrickableApiException(message, cause)