//
//  RebrickableModels.swift
//  ios
//
//  Created by Brixie Team
//

import Foundation

// MARK: - Set Models
struct RebrickableSet: Codable, Identifiable {
    let setNum: String
    let name: String
    let year: Int
    let themeId: Int
    let numParts: Int
    let setImageUrl: String?
    let setUrl: String
    let lastModifiedDt: String
    
    var id: String { setNum }
    
    enum CodingKeys: String, CodingKey {
        case setNum = "set_num"
        case name
        case year
        case themeId = "theme_id"
        case numParts = "num_parts"
        case setImageUrl = "set_img_url"
        case setUrl = "set_url"
        case lastModifiedDt = "last_modified_dt"
    }
}

struct RebrickableSetsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RebrickableSet]
}

// MARK: - Theme Models
struct RebrickableTheme: Codable, Identifiable {
    let id: Int
    let parentId: Int?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentId = "parent_id"
        case name
    }
}

struct RebrickableThemesResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RebrickableTheme]
}

// MARK: - Part Models
struct RebrickablePart: Codable, Identifiable {
    let partNum: String
    let name: String
    let partCatId: Int
    let partUrl: String
    let partImageUrl: String?
    let externalIds: [String: [String]]?
    let printOf: String?
    
    var id: String { partNum }
    
    enum CodingKeys: String, CodingKey {
        case partNum = "part_num"
        case name
        case partCatId = "part_cat_id"
        case partUrl = "part_url"
        case partImageUrl = "part_img_url"
        case externalIds = "external_ids"
        case printOf = "print_of"
    }
}

struct RebrickablePartsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RebrickablePart]
}

// MARK: - Color Models
struct RebrickableColor: Codable, Identifiable {
    let id: Int
    let name: String
    let rgb: String
    let isTrans: Bool
    let externalIds: [String: [String]]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rgb
        case isTrans = "is_trans"
        case externalIds = "external_ids"
    }
}

struct RebrickableColorsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RebrickableColor]
}

// MARK: - Error Models
struct RebrickableError: Codable, Error {
    let detail: String?
    let code: String?
    
    var localizedDescription: String {
        return detail ?? "An unknown error occurred"
    }
}

// MARK: - Search Models
struct RebrickableSearchQuery {
    let search: String?
    let theme: Int?
    let minParts: Int?
    let maxParts: Int?
    let minYear: Int?
    let maxYear: Int?
    let ordering: String?
    let pageSize: Int?
    let page: Int?
    
    func queryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        if let search = search, !search.isEmpty {
            items.append(URLQueryItem(name: "search", value: search))
        }
        if let theme = theme {
            items.append(URLQueryItem(name: "theme_id", value: "\(theme)"))
        }
        if let minParts = minParts {
            items.append(URLQueryItem(name: "min_parts", value: "\(minParts)"))
        }
        if let maxParts = maxParts {
            items.append(URLQueryItem(name: "max_parts", value: "\(maxParts)"))
        }
        if let minYear = minYear {
            items.append(URLQueryItem(name: "min_year", value: "\(minYear)"))
        }
        if let maxYear = maxYear {
            items.append(URLQueryItem(name: "max_year", value: "\(maxYear)"))
        }
        if let ordering = ordering {
            items.append(URLQueryItem(name: "ordering", value: ordering))
        }
        if let pageSize = pageSize {
            items.append(URLQueryItem(name: "page_size", value: "\(pageSize)"))
        }
        if let page = page {
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        return items
    }
}