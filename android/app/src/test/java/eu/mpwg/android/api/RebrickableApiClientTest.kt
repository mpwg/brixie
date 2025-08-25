package eu.mpwg.android.api

import eu.mpwg.android.api.models.ApiResponse
import eu.mpwg.android.api.models.LegoSet
import kotlinx.coroutines.test.runTest
import org.junit.Test
import org.junit.Assert.*

/**
 * Unit tests for RebrickableApiClient interface and basic functionality
 */
class RebrickableApiClientTest {

    @Test
    fun `create API client instance`() {
        val apiClient = RebrickableApi.createInstance("test_api_key")
        assertNotNull("API client should not be null", apiClient)
    }

    @Test
    fun `singleton instance returns same object`() {
        val instance1 = RebrickableApi.getInstance()
        val instance2 = RebrickableApi.getInstance()
        assertSame("Singleton should return same instance", instance1, instance2)
    }

    @Test
    fun `API client configuration is correct`() = runTest {
        // Test that the API client can be instantiated with different API keys
        val client1 = RebrickableApi.createInstance("key1")
        val client2 = RebrickableApi.createInstance("key2")
        
        assertNotNull("Client 1 should not be null", client1)
        assertNotNull("Client 2 should not be null", client2)
        // These should be different instances since they have different API keys
        assertNotSame("Different API keys should create different instances", client1, client2)
    }

    @Test
    fun `API response model structure is valid`() {
        // Test that our data models can be constructed properly
        val legoSet = LegoSet(
            setNum = "8880-1",
            name = "Technic Super Car",
            year = 1994,
            themeId = 1,
            numParts = 1343,
            setImgUrl = "https://cdn.rebrickable.com/media/sets/8880-1/12345.jpg",
            setUrl = "https://rebrickable.com/sets/8880-1/",
            lastModifiedDt = "2021-01-01T00:00:00Z"
        )
        
        assertEquals("Set number should match", "8880-1", legoSet.setNum)
        assertEquals("Set name should match", "Technic Super Car", legoSet.name)
        assertEquals("Year should match", 1994, legoSet.year)
        assertEquals("Part count should match", 1343, legoSet.numParts)
        
        val apiResponse = ApiResponse(
            count = 1,
            next = null,
            previous = null,
            results = listOf(legoSet)
        )
        
        assertEquals("Response count should match", 1, apiResponse.count)
        assertEquals("Response should contain one result", 1, apiResponse.results.size)
        assertEquals("First result should be our set", legoSet, apiResponse.results[0])
    }

    @Test
    fun `exception types are properly defined`() {
        // Test that our custom exceptions can be created and have appropriate messages
        val networkException = NetworkException("Test network error")
        assertTrue("NetworkException should be instance of RebrickableApiException", 
                  networkException is RebrickableApiException)
        assertEquals("Network exception message should match", "Test network error", networkException.message)
        
        val authException = AuthenticationException("Test auth error")
        assertTrue("AuthenticationException should be instance of RebrickableApiException", 
                  authException is RebrickableApiException)
        assertEquals("Auth exception message should match", "Test auth error", authException.message)
        
        val notFoundException = NotFoundException("Test not found error")
        assertTrue("NotFoundException should be instance of RebrickableApiException", 
                  notFoundException is RebrickableApiException)
        assertEquals("NotFound exception message should match", "Test not found error", notFoundException.message)
    }
}