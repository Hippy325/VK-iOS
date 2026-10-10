//
//  NewsFeedResponseDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

/// Ответ метода `newsfeed.get`.
struct NewsFeedResponseDTO: Decodable {
    let items: [NewsItemDTO]
    let profiles: [ProfileDTO]?
    let groups: [GroupDTO]?
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}
