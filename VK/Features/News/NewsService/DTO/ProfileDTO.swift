//
//  ProfileDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

/// Пользователь из `profiles`.
struct ProfileDTO: Decodable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let screenName: String?
    let photo100: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case screenName = "screen_name"
        case photo100 = "photo_100"
    }
}
