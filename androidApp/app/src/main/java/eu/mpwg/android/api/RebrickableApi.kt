package eu.mpwg.android.api

/**
 * Factory for creating instances of RebrickableApiClient
 */
object RebrickableApi {
    
    @Volatile
    private var instance: RebrickableApiClient? = null
    
    /**
     * Get singleton instance of RebrickableApiClient
     * @return RebrickableApiClient instance
     */
    fun getInstance(): RebrickableApiClient {
        return instance ?: synchronized(this) {
            instance ?: RebrickableApiClientImpl().also { instance = it }
        }
    }
    
    /**
     * Create a new instance of RebrickableApiClient with custom API key
     * @param apiKey Custom API key to use
     * @return RebrickableApiClient instance
     */
    fun createInstance(apiKey: String): RebrickableApiClient {
        return RebrickableApiClientImpl(apiKey)
    }
    
    /**
     * Reset the singleton instance (useful for testing)
     */
    internal fun resetInstance() {
        synchronized(this) {
            (instance as? RebrickableApiClientImpl)?.close()
            instance = null
        }
    }
}