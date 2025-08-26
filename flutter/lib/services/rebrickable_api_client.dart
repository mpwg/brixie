import '../models/api_response.dart';
import '../models/lego_models.dart';

/// Interface for the Rebrickable API client
abstract class RebrickableApiClient {
  /// Search for LEGO sets with optional filters
  Future<ApiResponse<LegoSet>> getSets({
    String? search,
    int page = 1,
    int pageSize = 20,
    int? themeId,
    int? minYear,
    int? maxYear,
    int? minParts,
    int? maxParts,
  });

  /// Get details for a specific LEGO set
  Future<LegoSet> getSet(String setNum);

  /// Search for LEGO parts with optional filters
  Future<ApiResponse<LegoPart>> getParts({
    String? search,
    int page = 1,
    int pageSize = 20,
    int? catId,
  });

  /// Get details for a specific LEGO part
  Future<LegoPart> getPart(String partNum);

  /// Get list of LEGO themes
  Future<ApiResponse<LegoTheme>> getThemes({
    int page = 1,
    int pageSize = 20,
  });

  /// Get list of LEGO colors
  Future<ApiResponse<LegoColor>> getColors({
    int page = 1,
    int pageSize = 20,
  });

  /// Cleanup resources
  void dispose();
}