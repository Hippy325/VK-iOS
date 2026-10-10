//
//  PhotoDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: Int?
    let ownerId: Int?
    let width: Int?
    let height: Int?
    let sizes: [PhotoSizeDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case width
        case height
        case sizes
    }
}

/// Одна копия фотографии в `sizes`.
struct PhotoSizeDTO: Decodable {
    let type: String?
    let url: String?
    let width: Int?
    let height: Int?
}
