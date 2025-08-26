package eu.mpwg.brixie.shared.api

import eu.mpwg.brixie.shared.api.models.LegoTheme
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class SharedModuleTest {
    
    @Test
    fun testLegoThemeCreation() {
        val theme = LegoTheme(
            id = 1,
            name = "Technic",
            parentId = null
        )
        
        assertEquals(1, theme.id)
        assertEquals("Technic", theme.name)
        assertEquals(null, theme.parentId)
    }
    
    @Test
    fun testApiClientFactoryCreation() {
        val client = RebrickableApi.getInstance()
        assertNotNull(client)
    }
    
    @Test
    fun testExceptionCreation() {
        val exception = NetworkException("Test network error")
        assertEquals("Test network error", exception.message)
    }
}