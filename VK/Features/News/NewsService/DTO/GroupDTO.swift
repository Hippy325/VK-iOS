//
//  GroupDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

nonisolated struct GroupDTO: Decodable {
    let id: Int
    let name: String?
    let screenName: String?
    let photo100: String?
    let photo200: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
