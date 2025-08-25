//
//  iosTests.swift
//  iosTests
//
//  Created by Matthias Wallner-Géhri on 25.08.25.
//

import Testing
@testable import ios

struct iosTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

// MARK: - Rebrickable API Tests
struct RebrickableAPITests {
    
    @Test func testAPIConfiguration() {
        let config = APIConfiguration.shared
        
        // Test that configuration exists
        #expect(config != nil)
        
        // Test base URL
        #expect(APIConfiguration.baseURL == "https://rebrickable.com/api/v3/")
    }
    
    @Test func testRebrickableSearchQuery() {
        let query = RebrickableSearchQuery(
            search: "star wars",
            theme: 158,
            minParts: 100,
            maxParts: 500,
            minYear: 2020,
            maxYear: 2024,
            ordering: "-year",
            pageSize: 10,
            page: 1
        )
        
        let queryItems = query.queryItems()
        
        #expect(queryItems.contains { $0.name == "search" && $0.value == "star wars" })
        #expect(queryItems.contains { $0.name == "theme_id" && $0.value == "158" })
        #expect(queryItems.contains { $0.name == "min_parts" && $0.value == "100" })
        #expect(queryItems.contains { $0.name == "max_parts" && $0.value == "500" })
        #expect(queryItems.contains { $0.name == "min_year" && $0.value == "2020" })
        #expect(queryItems.contains { $0.name == "max_year" && $0.value == "2024" })
        #expect(queryItems.contains { $0.name == "ordering" && $0.value == "-year" })
        #expect(queryItems.contains { $0.name == "page_size" && $0.value == "10" })
        #expect(queryItems.contains { $0.name == "page" && $0.value == "1" })
    }
    
    @Test func testRebrickableRequestBuilder() {
        // Test URL building without query items
        let simpleURL = RebrickableRequestBuilder.buildURL(endpoint: "lego/sets/")
        #expect(simpleURL != nil)
        #expect(simpleURL?.absoluteString.contains("lego/sets/") == true)
        
        // Test URL building with query items
        let queryItems = [URLQueryItem(name: "search", value: "millennium falcon")]
        let urlWithQuery = RebrickableRequestBuilder.buildURL(endpoint: "lego/sets/", queryItems: queryItems)
        #expect(urlWithQuery != nil)
        #expect(urlWithQuery?.absoluteString.contains("search=millennium%20falcon") == true)
    }
    
    @Test func testRebrickableSetDecoding() throws {
        let json = """
        {
            "set_num": "75192-1",
            "name": "Millennium Falcon",
            "year": 2017,
            "theme_id": 158,
            "num_parts": 7541,
            "set_img_url": "https://cdn.rebrickable.com/media/sets/75192-1/12345.jpg",
            "set_url": "https://rebrickable.com/sets/75192-1/millennium-falcon/",
            "last_modified_dt": "2017-10-01T00:00:00.000000Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let set = try decoder.decode(RebrickableSet.self, from: data)
        
        #expect(set.setNum == "75192-1")
        #expect(set.name == "Millennium Falcon")
        #expect(set.year == 2017)
        #expect(set.themeId == 158)
        #expect(set.numParts == 7541)
        #expect(set.id == "75192-1")
    }
    
    @Test func testRebrickableThemeDecoding() throws {
        let json = """
        {
            "id": 158,
            "parent_id": 153,
            "name": "Star Wars"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let theme = try decoder.decode(RebrickableTheme.self, from: data)
        
        #expect(theme.id == 158)
        #expect(theme.parentId == 153)
        #expect(theme.name == "Star Wars")
    }
    
    @Test func testRebrickablePartDecoding() throws {
        let json = """
        {
            "part_num": "3001",
            "name": "Brick 2 x 4",
            "part_cat_id": 1,
            "part_url": "https://rebrickable.com/parts/3001/brick-2-x-4/",
            "part_img_url": "https://cdn.rebrickable.com/media/parts/elements/300121.jpg",
            "external_ids": {
                "BrickLink": ["3001"],
                "BrickOwl": ["123456"]
            },
            "print_of": null
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let part = try decoder.decode(RebrickablePart.self, from: data)
        
        #expect(part.partNum == "3001")
        #expect(part.name == "Brick 2 x 4")
        #expect(part.partCatId == 1)
        #expect(part.id == "3001")
    }
    
    @Test func testRebrickableColorDecoding() throws {
        let json = """
        {
            "id": 4,
            "name": "Red",
            "rgb": "C91A09",
            "is_trans": false,
            "external_ids": {
                "BrickLink": ["5"],
                "BrickOwl": ["38"]
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let color = try decoder.decode(RebrickableColor.self, from: data)
        
        #expect(color.id == 4)
        #expect(color.name == "Red")
        #expect(color.rgb == "C91A09")
        #expect(color.isTrans == false)
    }
    
    @Test func testAPIErrorHandling() {
        let apiError = RebrickableAPIError.unauthorized
        #expect(apiError.errorDescription == "Unauthorized - check your API key")
        
        let rateLimitError = RebrickableAPIError.rateLimited
        #expect(rateLimitError.errorDescription == "Rate limit exceeded - please try again later")
        
        let serverError = RebrickableAPIError.serverError(500)
        #expect(serverError.errorDescription == "Server error (HTTP 500)")
    }
}
