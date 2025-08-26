# Rebrickable API Integration for iOS

This document provides comprehensive documentation for the Rebrickable API integration in the Brixie iOS app.

## Overview

The Rebrickable API integration enables the Brixie iOS app to retrieve and process LEGO set data directly from Rebrickable's v3 API. The implementation follows modern Swift practices using async/await, SwiftUI, and includes comprehensive error handling.

## Files Added

### Core API Files
- `RebrickableAPI.swift` - Main API client with async/await methods
- `RebrickableModels.swift` - Data models for API responses
- `APIConfiguration.swift` - Configuration management and request building

### Updated Files
- `ContentView.swift` - Updated to demonstrate API integration
- `Info.plist` - Added API key configuration
- `iosTests.swift` - Added comprehensive unit tests

## API Configuration

### API Key Setup

The API key is configured to be injected during build time. The system checks for the API key in the following order:

1. **Environment Variable** (for development): `API_KEY_REBRICKABLE`
2. **Bundle Resource** (for release): `APIKeys.plist` file
3. **Info.plist** (build-time injection): `$(API_KEY_REBRICKABLE)`

### Build Configuration

To configure the API key during build:

1. Set the `API_KEY_REBRICKABLE` environment variable in your GitHub repository secrets
2. Configure your build system to inject the variable into `Info.plist`
3. For Xcode builds, set the environment variable in your scheme

Example build command:
```bash
xcodebuild -workspace Brixie.xcworkspace -scheme Brixie \
  API_KEY_REBRICKABLE="your_api_key_here" \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build
```

## API Client Usage

### Basic Usage

```swift
import SwiftUI

struct MyView: View {
    @StateObject private var api = RebrickableAPI.shared
    @State private var sets: [RebrickableSet] = []
    
    var body: some View {
        List(sets, id: \.setNum) { set in
            Text(set.name)
        }
        .task {
            await loadSets()
        }
    }
    
    private func loadSets() async {
        do {
            let response = try await api.getFeaturedSets(limit: 10)
            sets = response.results
        } catch {
            print("Error loading sets: \(error)")
        }
    }
}
```

### Search Functionality

```swift
// Search for sets by name
let response = try await api.searchSets(name: "Star Wars", limit: 20)

// Advanced search with filters
let query = RebrickableSearchQuery(
    search: "millennium falcon",
    theme: 158, // Star Wars theme ID
    minParts: 1000,
    maxParts: 10000,
    minYear: 2015,
    maxYear: 2024,
    ordering: "-year",
    pageSize: 20,
    page: 1
)
let response = try await api.getSets(query: query)
```

### Error Handling

```swift
do {
    let sets = try await api.getFeaturedSets()
    // Handle success
} catch RebrickableAPIError.unauthorized {
    // Handle authentication error
} catch RebrickableAPIError.rateLimited {
    // Handle rate limiting
} catch RebrickableAPIError.notConfigured {
    // Handle missing API key
} catch {
    // Handle other errors
}
```

## Data Models

### RebrickableSet
Represents a LEGO set from the API:
```swift
struct RebrickableSet: Codable, Identifiable {
    let setNum: String      // Set number (e.g., "75192-1")
    let name: String        // Set name
    let year: Int          // Release year
    let themeId: Int       // Theme ID
    let numParts: Int      // Number of parts
    let setImageUrl: String? // Image URL
    let setUrl: String     // Rebrickable URL
    let lastModifiedDt: String // Last modified date
}
```

### RebrickableTheme
Represents a LEGO theme:
```swift
struct RebrickableTheme: Codable, Identifiable {
    let id: Int
    let parentId: Int?     // Parent theme ID (for sub-themes)
    let name: String       // Theme name
}
```

### RebrickablePart
Represents a LEGO part:
```swift
struct RebrickablePart: Codable, Identifiable {
    let partNum: String    // Part number
    let name: String       // Part name
    let partCatId: Int     // Part category ID
    let partUrl: String    // Rebrickable URL
    let partImageUrl: String? // Image URL
    let externalIds: [String: [String]]? // External IDs
    let printOf: String?   // Print variant info
}
```

### RebrickableColor
Represents a LEGO color:
```swift
struct RebrickableColor: Codable, Identifiable {
    let id: Int
    let name: String       // Color name
    let rgb: String        // RGB hex value
    let isTrans: Bool      // Transparent flag
    let externalIds: [String: [String]]? // External IDs
}
```

## API Methods

### Sets API
- `getSets(query:)` - Get sets with optional filtering
- `getSet(setNumber:)` - Get specific set by number
- `searchSets(name:limit:)` - Search sets by name
- `getFeaturedSets(limit:)` - Get recent/featured sets

### Themes API
- `getThemes()` - Get all themes
- `getTheme(id:)` - Get specific theme by ID

### Parts API
- `getParts(query:)` - Get parts with optional filtering
- `getPart(partNumber:)` - Get specific part by number
- `searchParts(name:limit:)` - Search parts by name

### Colors API
- `getColors()` - Get all colors
- `getColor(id:)` - Get specific color by ID

### Utility Methods
- `testConnection()` - Test API connectivity
- `getFeaturedSets(limit:)` - Get latest releases

## Rate Limiting

The Rebrickable API has the following limits:
- 1,000 requests per minute
- 50,000 requests per day

The client automatically handles rate limiting errors and provides appropriate error messages.

## Testing

### Unit Tests

The implementation includes comprehensive unit tests covering:
- Data model JSON decoding
- API configuration
- Request building
- Error handling
- Search query building

Run tests with:
```bash
xcodebuild test -workspace Brixie.xcworkspace -scheme Brixie \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Integration Testing

To test with live API:
1. Set up your API key in the environment
2. Run the app and navigate to the "Sets" or "Themes" tabs
3. Verify data loads correctly
4. Test search functionality

## Security Considerations

1. **API Key Protection**: The API key is injected at build time and not stored in source code
2. **HTTPS Only**: All requests use HTTPS
3. **Error Information**: Sensitive error details are not exposed to users
4. **Rate Limiting**: Built-in respect for API rate limits

## Troubleshooting

### Common Issues

1. **"API key not configured" error**
   - Ensure the `API_KEY_REBRICKABLE` environment variable is set
   - Check Info.plist configuration
   - Verify build-time injection is working

2. **"Unauthorized" error**
   - Verify API key is valid
   - Check Rebrickable account status
   - Ensure API key has correct permissions

3. **Network errors**
   - Check internet connectivity
   - Verify Rebrickable API is accessible
   - Check for firewall/proxy issues

4. **Rate limiting**
   - Reduce request frequency
   - Implement caching if needed
   - Consider upgrading Rebrickable account

### Debug Mode

Enable debug logging by setting the environment variable:
```
REBRICKABLE_DEBUG=1
```

## Examples

### Complete Integration Example

```swift
import SwiftUI

struct LegoSetsView: View {
    @StateObject private var api = RebrickableAPI.shared
    @State private var sets: [RebrickableSet] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    List(sets) { set in
                        VStack(alignment: .leading) {
                            Text(set.name)
                                .font(.headline)
                            Text("Set #\(set.setNum) • \(set.year)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(set.numParts) parts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .searchable(text: $searchText)
                    .onSubmit(of: .search) {
                        Task { await searchSets() }
                    }
                }
            }
            .navigationTitle("LEGO Sets")
            .task {
                await loadFeaturedSets()
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
    
    private func loadFeaturedSets() async {
        isLoading = true
        do {
            let response = try await api.getFeaturedSets(limit: 20)
            sets = response.results
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func searchSets() async {
        guard !searchText.isEmpty else {
            await loadFeaturedSets()
            return
        }
        
        isLoading = true
        do {
            let response = try await api.searchSets(name: searchText, limit: 20)
            sets = response.results
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
```

This documentation provides everything needed to understand, implement, and maintain the Rebrickable API integration in the Brixie iOS app.