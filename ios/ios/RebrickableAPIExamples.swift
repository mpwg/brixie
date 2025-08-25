//
//  RebrickableAPIExamples.swift
//  ios
//
//  Created by Brixie Team
//

import Foundation

/**
 * Example usage patterns for the Rebrickable API integration
 * These examples show how to use the API client in various scenarios
 */

// MARK: - Basic Usage Examples

class RebrickableAPIExamples {
    
    /// Example 1: Load featured LEGO sets
    static func loadFeaturedSetsExample() async {
        let api = RebrickableAPI.shared
        
        do {
            print("Loading featured LEGO sets...")
            let response = try await api.getFeaturedSets(limit: 10)
            
            print("Found \(response.results.count) featured sets:")
            for set in response.results {
                print("- \(set.name) (\(set.setNum)) - \(set.year) - \(set.numParts) parts")
            }
        } catch RebrickableAPIError.notConfigured {
            print("❌ API key not configured. Please set API_KEY_REBRICKABLE.")
        } catch RebrickableAPIError.unauthorized {
            print("❌ Unauthorized. Please check your API key.")
        } catch RebrickableAPIError.rateLimited {
            print("❌ Rate limit exceeded. Please try again later.")
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    /// Example 2: Search for specific sets
    static func searchSetsExample() async {
        let api = RebrickableAPI.shared
        
        do {
            print("Searching for Star Wars sets...")
            let response = try await api.searchSets(name: "Star Wars", limit: 5)
            
            print("Found \(response.results.count) Star Wars sets:")
            for set in response.results {
                print("- \(set.name) (\(set.setNum)) - \(set.year)")
            }
        } catch {
            print("❌ Search error: \(error.localizedDescription)")
        }
    }
    
    /// Example 3: Advanced search with filters
    static func advancedSearchExample() async {
        let api = RebrickableAPI.shared
        
        let query = RebrickableSearchQuery(
            search: "millennium falcon",
            theme: 158, // Star Wars theme
            minParts: 1000,
            maxParts: 10000,
            minYear: 2000,
            maxYear: 2024,
            ordering: "-year",
            pageSize: 10,
            page: 1
        )
        
        do {
            print("Advanced search for Millennium Falcon sets...")
            let response = try await api.getSets(query: query)
            
            print("Found \(response.results.count) matching sets:")
            for set in response.results {
                print("- \(set.name) (\(set.setNum)) - \(set.year) - \(set.numParts) parts")
            }
        } catch {
            print("❌ Advanced search error: \(error.localizedDescription)")
        }
    }
    
    /// Example 4: Load themes
    static func loadThemesExample() async {
        let api = RebrickableAPI.shared
        
        do {
            print("Loading LEGO themes...")
            let response = try await api.getThemes()
            
            // Show first 20 themes
            let themesToShow = Array(response.results.prefix(20))
            print("First \(themesToShow.count) themes:")
            for theme in themesToShow {
                let parentInfo = theme.parentId != nil ? " (sub-theme)" : ""
                print("- \(theme.name)\(parentInfo)")
            }
        } catch {
            print("❌ Themes error: \(error.localizedDescription)")
        }
    }
    
    /// Example 5: Get specific set details
    static func getSetDetailsExample() async {
        let api = RebrickableAPI.shared
        
        do {
            print("Getting details for Millennium Falcon set...")
            let set = try await api.getSet(setNumber: "75192-1")
            
            print("Set Details:")
            print("- Name: \(set.name)")
            print("- Set Number: \(set.setNum)")
            print("- Year: \(set.year)")
            print("- Parts: \(set.numParts)")
            print("- Theme ID: \(set.themeId)")
            if let imageUrl = set.setImageUrl {
                print("- Image: \(imageUrl)")
            }
        } catch {
            print("❌ Set details error: \(error.localizedDescription)")
        }
    }
    
    /// Example 6: Test API connection
    static func testConnectionExample() async {
        let api = RebrickableAPI.shared
        
        do {
            print("Testing API connection...")
            let isConnected = try await api.testConnection()
            
            if isConnected {
                print("✅ API connection successful!")
            } else {
                print("❌ API connection failed.")
            }
        } catch {
            print("❌ Connection test error: \(error.localizedDescription)")
        }
    }
    
    /// Example 7: Search parts
    static func searchPartsExample() async {
        let api = RebrickableAPI.shared
        
        do {
            print("Searching for brick parts...")
            let response = try await api.searchParts(name: "brick", limit: 10)
            
            print("Found \(response.results.count) brick parts:")
            for part in response.results {
                print("- \(part.name) (\(part.partNum))")
            }
        } catch {
            print("❌ Parts search error: \(error.localizedDescription)")
        }
    }
    
    /// Example 8: Load colors
    static func loadColorsExample() async {
        let api = RebrickableAPI.shared
        
        do {
            print("Loading LEGO colors...")
            let response = try await api.getColors()
            
            // Show first 10 colors
            let colorsToShow = Array(response.results.prefix(10))
            print("First \(colorsToShow.count) colors:")
            for color in colorsToShow {
                let transInfo = color.isTrans ? " (transparent)" : ""
                print("- \(color.name) (#\(color.rgb))\(transInfo)")
            }
        } catch {
            print("❌ Colors error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Usage in SwiftUI Views

#if canImport(SwiftUI)
import SwiftUI

/**
 * Example SwiftUI view demonstrating API integration
 */
struct RebrickableAPIExampleView: View {
    @StateObject private var api = RebrickableAPI.shared
    @State private var sets: [RebrickableSet] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading LEGO sets...")
                        .frame(maxHeight: .infinity)
                } else if sets.isEmpty {
                    Text("No sets found")
                        .foregroundColor(.secondary)
                        .frame(maxHeight: .infinity)
                } else {
                    List(sets) { set in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(set.name)
                                .font(.headline)
                            
                            HStack {
                                Text("Set #\(set.setNum)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(set.year)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text("\(set.numParts) parts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("LEGO Sets")
            .searchable(text: $searchText, prompt: "Search sets...")
            .onSubmit(of: .search) {
                Task { await performSearch() }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Featured") {
                        Task { await loadFeaturedSets() }
                    }
                }
            }
            .task {
                await loadFeaturedSets()
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private func loadFeaturedSets() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await api.getFeaturedSets(limit: 20)
            await MainActor.run {
                self.sets = response.results
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    private func performSearch() async {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            await loadFeaturedSets()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await api.searchSets(name: searchText, limit: 20)
            await MainActor.run {
                self.sets = response.results
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
}

struct RebrickableAPIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        RebrickableAPIExampleView()
    }
}
#endif