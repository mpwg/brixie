package eu.mpwg.android.api

import android.util.Log
import eu.mpwg.android.BuildConfig
import eu.mpwg.android.api.models.ApiError
import eu.mpwg.android.api.models.ApiResponse
import eu.mpwg.android.api.models.LegoColor
import eu.mpwg.android.api.models.LegoPart
import eu.mpwg.android.api.models.LegoSet
import eu.mpwg.android.api.models.LegoTheme
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.engine.android.Android
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
    private val apiKey: String = BuildConfig.REBRICKABLE_API_KEY
) : RebrickableApiClient {

    companion object {
        private const val TAG = "RebrickableApiClient"
        private const val BASE_URL = "https://rebrickable.com/api/v3/lego/"
        private const val MAX_PAGE_SIZE = 1000
    }

    private val httpClient = HttpClient(Android) {
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
                    Log.v(TAG, message)
                }
            }
            level = if (BuildConfig.DEBUG) LogLevel.INFO else LogLevel.NONE
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
    ): Result<ApiResponse<LegoSet>> = withContext(Dispatchers.IO) {
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

    override suspend fun getSet(setNum: String): Result<LegoSet> = withContext(Dispatchers.IO) {
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
    ): Result<ApiResponse<LegoPart>> = withContext(Dispatchers.IO) {
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

    override suspend fun getPart(partNum: String): Result<LegoPart> = withContext(Dispatchers.IO) {
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
    ): Result<ApiResponse<LegoTheme>> = withContext(Dispatchers.IO) {
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
    ): Result<ApiResponse<LegoColor>> = withContext(Dispatchers.IO) {
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
     * Handles HTTP response and converts it to Result type
     */
    private suspend inline fun <reified T> handleResponse(response: HttpResponse): Result<T> {
        return try {
            when {
                response.status.isSuccess() -> {
                    val body = response.body<T>()
                    Result.success(body)
                }
                else -> {
                    val error = try {
                        response.body<ApiError>()
                    } catch (e: Exception) {
                        ApiError(detail = "Unknown error", code = response.status.value.toString())
                    }
                    Result.failure(mapHttpStatusToException(response.status, error))
                }
            }
        } catch (e: Exception) {
            Result.failure(ParseException("Failed to parse response", e))
        }
    }

    /**
     * Maps HTTP status codes to appropriate exceptions
     */
    private fun mapHttpStatusToException(status: HttpStatusCode, error: ApiError): RebrickableApiException {
        val message = error.detail ?: "API error"
        return when (status) {
            HttpStatusCode.BadRequest -> BadRequestException(message)
            HttpStatusCode.Unauthorized -> AuthenticationException(message)
            HttpStatusCode.NotFound -> NotFoundException(message)
            HttpStatusCode.TooManyRequests -> RateLimitException(message)
            in HttpStatusCode.InternalServerError..HttpStatusCode.GatewayTimeout -> 
                ServerException(message)
            else -> RebrickableApiException(message)
        }
    }

    /**
     * Handles general exceptions and converts them to appropriate API exceptions
     */
    private fun handleException(exception: Exception): RebrickableApiException {
        Log.e(TAG, "API call failed", exception)
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