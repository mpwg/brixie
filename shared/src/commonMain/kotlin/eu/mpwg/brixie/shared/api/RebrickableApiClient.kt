package eu.mpwg.brixie.shared.api

import eu.mpwg.brixie.shared.api.models.ApiResponse
import eu.mpwg.brixie.shared.api.models.LegoColor
import eu.mpwg.brixie.shared.api.models.LegoPart
import eu.mpwg.brixie.shared.api.models.LegoSet
import eu.mpwg.brixie.shared.api.models.LegoTheme

/**
 * Interface for Rebrickable API client operations
 */
interface RebrickableApiClient {
    
    /**
     * Search for LEGO sets
     * @param search Search query string
     * @param page Page number for pagination (default: 1)
     * @param pageSize Number of results per page (default: 20, max: 1000)
     * @param themeId Filter by theme ID
     * @param minYear Filter by minimum year
     * @param maxYear Filter by maximum year
     * @param minParts Filter by minimum number of parts
     * @param maxParts Filter by maximum number of parts
     * @return ApiResponse containing list of LegoSet
     */
    suspend fun getSets(
        search: String? = null,
        page: Int = 1,
        pageSize: Int = 20,
        themeId: Int? = null,
        minYear: Int? = null,
        maxYear: Int? = null,
        minParts: Int? = null,
        maxParts: Int? = null
    ): Result<ApiResponse<LegoSet>>
    
    /**
     * Get details of a specific LEGO set
     * @param setNum Set number (e.g., "8880-1")
     * @return LegoSet details
     */
    suspend fun getSet(setNum: String): Result<LegoSet>
    
    /**
     * Search for LEGO parts
     * @param search Search query string
     * @param page Page number for pagination (default: 1)
     * @param pageSize Number of results per page (default: 20, max: 1000)
     * @param catId Filter by part category ID
     * @return ApiResponse containing list of LegoPart
     */
    suspend fun getParts(
        search: String? = null,
        page: Int = 1,
        pageSize: Int = 20,
        catId: Int? = null
    ): Result<ApiResponse<LegoPart>>
    
    /**
     * Get details of a specific LEGO part
     * @param partNum Part number (e.g., "3001")
     * @return LegoPart details
     */
    suspend fun getPart(partNum: String): Result<LegoPart>
    
    /**
     * Get all LEGO themes
     * @param page Page number for pagination (default: 1)
     * @param pageSize Number of results per page (default: 20, max: 1000)
     * @return ApiResponse containing list of LegoTheme
     */
    suspend fun getThemes(
        page: Int = 1,
        pageSize: Int = 20
    ): Result<ApiResponse<LegoTheme>>
    
    /**
     * Get all LEGO colors
     * @param page Page number for pagination (default: 1)
     * @param pageSize Number of results per page (default: 20, max: 1000)
     * @return ApiResponse containing list of LegoColor
     */
    suspend fun getColors(
        page: Int = 1,
        pageSize: Int = 20
    ): Result<ApiResponse<LegoColor>>
}