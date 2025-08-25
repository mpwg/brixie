package eu.mpwg.android.api

import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * Example usage of the Rebrickable API client
 * 
 * This class demonstrates how to use the RebrickableApiClient to interact with the Rebrickable API.
 * It shows basic operations like searching for sets, getting set details, and handling errors.
 */
class RebrickableApiExample {

    companion object {
        private const val TAG = "RebrickableApiExample"
    }

    private val apiClient: RebrickableApiClient = RebrickableApi.getInstance()

    /**
     * Example: Search for LEGO sets containing "technic" in their name
     */
    fun searchTechnicSets() {
        CoroutineScope(Dispatchers.Main).launch {
            Log.d(TAG, "Searching for Technic sets...")
            
            val result = apiClient.getSets(
                search = "technic",
                page = 1,
                pageSize = 10
            )
            
            result.fold(
                onSuccess = { response ->
                    Log.d(TAG, "Found ${response.count} Technic sets")
                    response.results.forEach { set ->
                        Log.d(TAG, "Set: ${set.name} (${set.setNum}) - ${set.numParts} parts")
                    }
                },
                onFailure = { exception ->
                    Log.e(TAG, "Failed to search for sets", exception)
                    handleApiError(exception)
                }
            )
        }
    }

    /**
     * Example: Get details for a specific LEGO set
     */
    fun getSetDetails(setNum: String) {
        CoroutineScope(Dispatchers.Main).launch {
            Log.d(TAG, "Getting details for set: $setNum")
            
            val result = apiClient.getSet(setNum)
            
            result.fold(
                onSuccess = { set ->
                    Log.d(TAG, "Set Details:")
                    Log.d(TAG, "  Name: ${set.name}")
                    Log.d(TAG, "  Year: ${set.year}")
                    Log.d(TAG, "  Parts: ${set.numParts}")
                    Log.d(TAG, "  Theme ID: ${set.themeId}")
                    set.setImgUrl?.let { url ->
                        Log.d(TAG, "  Image: $url")
                    }
                },
                onFailure = { exception ->
                    Log.e(TAG, "Failed to get set details for $setNum", exception)
                    handleApiError(exception)
                }
            )
        }
    }

    /**
     * Example: Search for LEGO parts
     */
    fun searchParts(query: String) {
        CoroutineScope(Dispatchers.Main).launch {
            Log.d(TAG, "Searching for parts: $query")
            
            val result = apiClient.getParts(
                search = query,
                page = 1,
                pageSize = 5
            )
            
            result.fold(
                onSuccess = { response ->
                    Log.d(TAG, "Found ${response.count} parts matching '$query'")
                    response.results.forEach { part ->
                        Log.d(TAG, "Part: ${part.name} (${part.partNum})")
                    }
                },
                onFailure = { exception ->
                    Log.e(TAG, "Failed to search for parts", exception)
                    handleApiError(exception)
                }
            )
        }
    }

    /**
     * Example: Get all available LEGO themes
     */
    fun getAllThemes() {
        CoroutineScope(Dispatchers.Main).launch {
            Log.d(TAG, "Getting all LEGO themes...")
            
            val result = apiClient.getThemes(page = 1, pageSize = 50)
            
            result.fold(
                onSuccess = { response ->
                    Log.d(TAG, "Found ${response.count} themes")
                    response.results.forEach { theme ->
                        Log.d(TAG, "Theme: ${theme.name} (ID: ${theme.id})")
                    }
                },
                onFailure = { exception ->
                    Log.e(TAG, "Failed to get themes", exception)
                    handleApiError(exception)
                }
            )
        }
    }

    /**
     * Example: Get LEGO colors
     */
    fun getAllColors() {
        CoroutineScope(Dispatchers.Main).launch {
            Log.d(TAG, "Getting LEGO colors...")
            
            val result = apiClient.getColors(page = 1, pageSize = 20)
            
            result.fold(
                onSuccess = { response ->
                    Log.d(TAG, "Found ${response.count} colors")
                    response.results.forEach { color ->
                        Log.d(TAG, "Color: ${color.name} (RGB: ${color.rgb}, Transparent: ${color.isTrans})")
                    }
                },
                onFailure = { exception ->
                    Log.e(TAG, "Failed to get colors", exception)
                    handleApiError(exception)
                }
            )
        }
    }

    /**
     * Handle different types of API errors appropriately
     */
    private fun handleApiError(exception: Throwable) {
        when (exception) {
            is AuthenticationException -> {
                Log.e(TAG, "Authentication failed. Please check your API key.")
                // In a real app, you might redirect to settings or show a dialog
            }
            is NetworkException -> {
                Log.e(TAG, "Network error. Please check your internet connection.")
                // In a real app, you might show a retry button
            }
            is RateLimitException -> {
                Log.e(TAG, "Rate limit exceeded. Please wait before making more requests.")
                // In a real app, you might implement exponential backoff
            }
            is NotFoundException -> {
                Log.e(TAG, "Requested resource not found.")
                // In a real app, you might show a "not found" message
            }
            is ServerException -> {
                Log.e(TAG, "Server error. Please try again later.")
                // In a real app, you might show a generic error message
            }
            else -> {
                Log.e(TAG, "Unknown error occurred: ${exception.message}")
                // In a real app, you might report this to crash analytics
            }
        }
    }
}