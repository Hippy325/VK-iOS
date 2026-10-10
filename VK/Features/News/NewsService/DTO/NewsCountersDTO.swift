//
//  NewsCountersDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

/// VK отдаёт булевы значения как 0/1, поэтому здесь `Int`, а перевод — в маппере.

struct LikesDTO: Decodable {
    let count: Int?
    let userLikes: Int?
    let canLike: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
    }
}

struct CommentsDTO: Decodable {
    let count: Int?
    let canPost: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
    }
}

struct RepostsDTO: Decodable {
    let count: Int?
    let userReposted: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}
