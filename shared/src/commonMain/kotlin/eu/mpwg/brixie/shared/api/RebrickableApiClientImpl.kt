package eu.mpwg.brixie.shared.api

import eu.mpwg.brixie.shared.api.models.ApiError
import eu.mpwg.brixie.shared.api.models.ApiResponse
import eu.mpwg.brixie.shared.api.models.LegoColor
import eu.mpwg.brixie.shared.api.models.LegoPart
import eu.mpwg.brixie.shared.api.models.LegoSet
import eu.mpwg.brixie.shared.api.models.LegoTheme
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.defaultRequest
import io.ktor.client.plugins.logging.LogLevel
import io.ktor.client.plugins.logging.Logger
import io.ktor.client.plugins.logging.Logging
import io.ktor.client.request.get
import io.ktor.client.request.parameter
import io.ktor.client.statement.HttpResponse
import io.ktor.http.HttpStatusCode
import io.ktor.http.isSuccess
import io.ktor.serialization.kotlinx.json.json
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json

/**
 * Implementation of RebrickableApiClient using Ktor HTTP client
 */
class RebrickableApiClientImpl(
    private val apiKey: String = getApiKey()
) : RebrickableApiClient {

    companion object {
        private const val TAG = "RebrickableApiClient"
        private const val BASE_URL = "https://rebrickable.com/api/v3/lego/"
        private const val MAX_PAGE_SIZE = 1000
    }

    private val httpClient = HttpClient(createHttpClientEngine()) {
        defaultRequest {
            url(BASE_URL)
        }
        
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true
                isLenient = true
                encodeDefaults = false
            })
        }
        
        install(Logging) {
            logger = object : Logger {
                override fun log(message: String) {
                    platformLog(TAG, message)
                }
            }
            level = if (isDebugMode()) LogLevel.INFO else LogLevel.NONE
        }
    }

    override suspend fun getSets(
        search: String?,
        page: Int,
        pageSize: Int,
        themeId: Int?,
        minYear: Int?,
        maxYear: Int?,
        minParts: Int?,
        maxParts: Int?
    ): Result<ApiResponse<LegoSet>> = withContext(Dispatchers.Default) {
        try {
            val response: HttpResponse = httpClient.get("sets/") {
                parameter("key", apiKey)
                parameter("page", page)
                parameter("page_size", pageSize.coerceAtMost(MAX_PAGE_SIZE))
                search?.let { parameter("search", it) }
                themeId?.let { parameter("theme_id", it) }
                minYear?.let { parameter("min_year", it) }
                maxYear?.let { parameter("max_year", it) }
                minParts?.let { parameter("min_parts", it) }
                maxParts?.let { parameter("max_parts", it) }
            }
            handleResponse(response)
        } catch (e: Exception) {
            Result.failure(handleException(e))
        }
    }

    override suspend fun getSet(setNum: String): Result<LegoSet> = withContext(Dispatchers.Default) {
        try {
            val response: HttpResponse = httpClient.get("sets/$setNum/") {
                parameter("key", apiKey)
            }
            handleResponse(response)
        } catch (e: Exception) {
            Result.failure(handleException(e))
        }
    }

    override suspend fun getParts(
        search: String?,
        page: Int,
        pageSize: Int,
        catId: Int?
    ): Result<ApiResponse<LegoPart>> = withContext(Dispatchers.Default) {
        try {
            val response: HttpResponse = httpClient.get("parts/") {
                parameter("key", apiKey)
                parameter("page", page)
                parameter("page_size", pageSize.coerceAtMost(MAX_PAGE_SIZE))
                search?.let { parameter("search", it) }
                catId?.let { parameter("part_cat_id", it) }
            }
            handleResponse(response)
        } catch (e: Exception) {
            Result.failure(handleException(e))
        }
    }

    override suspend fun getPart(partNum: String): Result<LegoPart> = withContext(Dispatchers.Default) {
        try {
            val response: HttpResponse = httpClient.get("parts/$partNum/") {
                parameter("key", apiKey)
            }
            handleResponse(response)
        } catch (e: Exception) {
            Result.failure(handleException(e))
        }
    }

    override suspend fun getThemes(
        page: Int,
        pageSize: Int
    ): Result<ApiResponse<LegoTheme>> = withContext(Dispatchers.Default) {
        try {
            val response: HttpResponse = httpClient.get("themes/") {
                parameter("key", apiKey)
                parameter("page", page)
                parameter("page_size", pageSize.coerceAtMost(MAX_PAGE_SIZE))
            }
            handleResponse(response)
        } catch (e: Exception) {
            Result.failure(handleException(e))
        }
    }

    override suspend fun getColors(
        page: Int,
        pageSize: Int
    ): Result<ApiResponse<LegoColor>> = withContext(Dispatchers.Default) {
        try {
            val response: HttpResponse = httpClient.get("colors/") {
                parameter("key", apiKey)
                parameter("page", page)
                parameter("page_size", pageSize.coerceAtMost(MAX_PAGE_SIZE))
            }
            handleResponse(response)
        } catch (e: Exception) {
            Result.failure(handleException(e))
        }
    }

    /**
     * Generic response handler for all API calls
     */
    private suspend inline fun <reified T> handleResponse(response: HttpResponse): Result<T> {
        return try {
            if (response.status.isSuccess()) {
                val data: T = response.body()
                Result.success(data)
            } else {
                val error = when (response.status) {
                    HttpStatusCode.Unauthorized -> AuthenticationException("Invalid API key")
                    HttpStatusCode.NotFound -> NotFoundException("Resource not found")
                    HttpStatusCode.BadRequest -> BadRequestException("Invalid request parameters")
                    HttpStatusCode.TooManyRequests -> RateLimitException("Rate limit exceeded")
                    else -> {
                        try {
                            val errorBody: ApiError = response.body()
                            ServerException(errorBody.detail ?: "Server error: ${response.status}")
                        } catch (e: Exception) {
                            ServerException("Server error: ${response.status}")
                        }
                    }
                }
                Result.failure(error)
            }
        } catch (e: Exception) {
            Result.failure(ParseException("Failed to parse response", e))
        }
    }

    /**
     * Convert generic exceptions to domain-specific exceptions
     */
    private fun handleException(exception: Throwable): RebrickableApiException {
        return when (exception) {
            is RebrickableApiException -> exception
            else -> NetworkException("Network error: ${exception.message}", exception)
        }
    }

    /**
     * Cleanup resources when client is no longer needed
     */
    fun close() {
        httpClient.close()
    }
}