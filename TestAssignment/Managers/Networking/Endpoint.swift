//
//  Endpoint.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import Foundation

enum Endpoint {
    
    static let baseURL = "https://api.unsplash.com"
    
    case randomPhotos
    case search
    case photo(id: String)
    
    var description: String {
        switch self {
        case .randomPhotos:
            return "/photos/random"
        case .search:
            return "/search/photos"
        case .photo(let id):
            return "/photos/\(id)"
        }
    }
}
