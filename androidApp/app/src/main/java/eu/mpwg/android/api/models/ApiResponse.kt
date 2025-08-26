package eu.mpwg.android.api.models

import kotlinx.serialization.Serializable

/**
 * Generic API response wrapper for paginated results from Rebrickable API
 */
@Serializable
data class ApiResponse<T>(
    val count: Int,
    val next: String? = null,
    val previous: String? = null,
    val results: List<T>
)

/**
 * API error response structure
 */
@Serializable
data class ApiError(
    val detail: String? = null,
    val code: String? = null
)