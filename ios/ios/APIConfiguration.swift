//
//  APIConfiguration.swift
//  ios
//
//  Created by Brixie Team
//

import Foundation

// MARK: - API Configuration
class APIConfiguration {
    static let shared = APIConfiguration()
    
    private init() {}
    
    // Base URL for Rebrickable API v3
    static let baseURL = "https://rebrickable.com/api/v3/"
    
    // API Key - will be injected during build time
    var apiKey: String {
        // First try to get from environment variable (for development)
        if let envKey = ProcessInfo.processInfo.environment["API_KEY_REBRICKABLE"] {
            return envKey
        }
        
        // Then try to get from bundle (for release builds)
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let key = dict["API_KEY_REBRICKABLE"] as? String {
            return key
        }
        
        // Finally try Info.plist
        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY_REBRICKABLE") as? String {
            return key
        }
        
        // For development/testing purposes - should not be used in production
        return ""
    }
    
    // Check if API key is configured
    var isConfigured: Bool {
        !apiKey.isEmpty
    }
    
    // Rate limiting configuration
    static let requestsPerMinute = 1000 // Rebrickable allows 1000 requests per minute
    static let requestsPerDay = 50000   // and 50000 requests per day
}

// MARK: - Request Builder
struct RebrickableRequestBuilder {
    static func buildURL(endpoint: String, queryItems: [URLQueryItem] = []) -> URL? {
        guard var components = URLComponents(string: APIConfiguration.baseURL + endpoint) else {
            return nil
        }
        
        // Add API key to query items
        var allQueryItems = queryItems
        allQueryItems.append(URLQueryItem(name: "key", value: APIConfiguration.shared.apiKey))
        
        components.queryItems = allQueryItems.isEmpty ? nil : allQueryItems
        
        return components.url
    }
    
    static func buildRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Brixie-iOS/1.0", forHTTPHeaderField: "User-Agent")
        
        return request
    }
}