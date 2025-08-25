//
//  RebrickableAPI.swift
//  ios
//
//  Created by Brixie Team
//

import Foundation

// MARK: - API Errors
enum RebrickableAPIError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    case apiError(RebrickableError)
    case unauthorized
    case rateLimited
    case serverError(Int)
    case notConfigured
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .apiError(let error):
            return "API error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized - check your API key"
        case .rateLimited:
            return "Rate limit exceeded - please try again later"
        case .serverError(let code):
            return "Server error (HTTP \(code))"
        case .notConfigured:
            return "API key not configured"
        }
    }
}

// MARK: - API Client
@MainActor
class RebrickableAPI: ObservableObject {
    static let shared = RebrickableAPI()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    @Published var isLoading = false
    @Published var lastError: RebrickableAPIError?
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
        
        self.decoder = JSONDecoder()
        // Configure date formatter if needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    // MARK: - Generic Request Method
    private func performRequest<T: Codable>(
        endpoint: String,
        queryItems: [URLQueryItem] = [],
        responseType: T.Type
    ) async throws -> T {
        guard APIConfiguration.shared.isConfigured else {
            throw RebrickableAPIError.notConfigured
        }
        
        guard let url = RebrickableRequestBuilder.buildURL(endpoint: endpoint, queryItems: queryItems) else {
            throw RebrickableAPIError.invalidURL
        }
        
        let request = RebrickableRequestBuilder.buildRequest(for: url)
        
        do {
            isLoading = true
            lastError = nil
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RebrickableAPIError.invalidResponse
            }
            
            // Handle HTTP status codes
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw RebrickableAPIError.unauthorized
            case 429:
                throw RebrickableAPIError.rateLimited
            case 400...499:
                // Try to decode error response
                if let errorResponse = try? decoder.decode(RebrickableError.self, from: data) {
                    throw RebrickableAPIError.apiError(errorResponse)
                } else {
                    throw RebrickableAPIError.serverError(httpResponse.statusCode)
                }
            case 500...599:
                throw RebrickableAPIError.serverError(httpResponse.statusCode)
            default:
                throw RebrickableAPIError.serverError(httpResponse.statusCode)
            }
            
            do {
                let result = try decoder.decode(responseType, from: data)
                return result
            } catch {
                throw RebrickableAPIError.decodingError(error)
            }
            
        } catch let error as RebrickableAPIError {
            lastError = error
            isLoading = false
            throw error
        } catch {
            let apiError = RebrickableAPIError.networkError(error)
            lastError = apiError
            isLoading = false
            throw apiError
        }
    }
    
    // MARK: - Sets API
    
    /// Get all LEGO sets with optional filtering
    func getSets(query: RebrickableSearchQuery = RebrickableSearchQuery(
        search: nil, theme: nil, minParts: nil, maxParts: nil,
        minYear: nil, maxYear: nil, ordering: nil, pageSize: nil, page: nil
    )) async throws -> RebrickableSetsResponse {
        return try await performRequest(
            endpoint: "lego/sets/",
            queryItems: query.queryItems(),
            responseType: RebrickableSetsResponse.self
        )
    }
    
    /// Get a specific LEGO set by set number
    func getSet(setNumber: String) async throws -> RebrickableSet {
        return try await performRequest(
            endpoint: "lego/sets/\(setNumber)/",
            responseType: RebrickableSet.self
        )
    }
    
    /// Search sets by name
    func searchSets(name: String, limit: Int = 20) async throws -> RebrickableSetsResponse {
        let query = RebrickableSearchQuery(
            search: name, theme: nil, minParts: nil, maxParts: nil,
            minYear: nil, maxYear: nil, ordering: "-year", pageSize: limit, page: nil
        )
        return try await getSets(query: query)
    }
    
    // MARK: - Themes API
    
    /// Get all themes
    func getThemes() async throws -> RebrickableThemesResponse {
        return try await performRequest(
            endpoint: "lego/themes/",
            responseType: RebrickableThemesResponse.self
        )
    }
    
    /// Get a specific theme by ID
    func getTheme(id: Int) async throws -> RebrickableTheme {
        return try await performRequest(
            endpoint: "lego/themes/\(id)/",
            responseType: RebrickableTheme.self
        )
    }
    
    // MARK: - Parts API
    
    /// Get all parts with optional filtering
    func getParts(query: RebrickableSearchQuery = RebrickableSearchQuery(
        search: nil, theme: nil, minParts: nil, maxParts: nil,
        minYear: nil, maxYear: nil, ordering: nil, pageSize: nil, page: nil
    )) async throws -> RebrickablePartsResponse {
        return try await performRequest(
            endpoint: "lego/parts/",
            queryItems: query.queryItems(),
            responseType: RebrickablePartsResponse.self
        )
    }
    
    /// Get a specific part by part number
    func getPart(partNumber: String) async throws -> RebrickablePart {
        return try await performRequest(
            endpoint: "lego/parts/\(partNumber)/",
            responseType: RebrickablePart.self
        )
    }
    
    /// Search parts by name
    func searchParts(name: String, limit: Int = 20) async throws -> RebrickablePartsResponse {
        let query = RebrickableSearchQuery(
            search: name, theme: nil, minParts: nil, maxParts: nil,
            minYear: nil, maxYear: nil, ordering: "name", pageSize: limit, page: nil
        )
        return try await getParts(query: query)
    }
    
    // MARK: - Colors API
    
    /// Get all colors
    func getColors() async throws -> RebrickableColorsResponse {
        return try await performRequest(
            endpoint: "lego/colors/",
            responseType: RebrickableColorsResponse.self
        )
    }
    
    /// Get a specific color by ID
    func getColor(id: Int) async throws -> RebrickableColor {
        return try await performRequest(
            endpoint: "lego/colors/\(id)/",
            responseType: RebrickableColor.self
        )
    }
    
    // MARK: - Convenience Methods
    
    /// Test API connectivity with a simple request
    func testConnection() async throws -> Bool {
        do {
            _ = try await getThemes()
            return true
        } catch {
            throw error
        }
    }
    
    /// Get featured sets (latest releases)
    func getFeaturedSets(limit: Int = 10) async throws -> RebrickableSetsResponse {
        let currentYear = Calendar.current.component(.year, from: Date())
        let query = RebrickableSearchQuery(
            search: nil, theme: nil, minParts: nil, maxParts: nil,
            minYear: currentYear - 1, maxYear: currentYear, ordering: "-year", pageSize: limit, page: nil
        )
        return try await getSets(query: query)
    }
}