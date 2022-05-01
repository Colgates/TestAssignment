//
//  Photo.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import Foundation

struct SearchResponse: Codable, Hashable {
    let total, totalPages: Int
    let results: [Photo]
}

struct Photo: Codable, Hashable {
    let id: String
    let createdAt: String
    let urls: Urls
    let user: User
    let location: Location
    let downloads: Int?
}

struct Urls: Codable, Hashable {
    let raw, full, regular, small: String
    let thumb, smallS3: String
}

struct User: Codable, Hashable {
    let id: String
    let name: String?
}

struct Location: Codable, Hashable {
    let title: String?
}
