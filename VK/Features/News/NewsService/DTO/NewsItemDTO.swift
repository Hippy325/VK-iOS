//
//  NewsItemDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

/// Одна запись ленты (`items[]`).
struct NewsItemDTO: Decodable {
    let type: String?
    let sourceId: Int
    let postId: Int?
    let postType: String?
    let date: Int
    let text: String?
    let attachments: [AttachmentDTO]?
    let likes: LikesDTO?
    let comments: CommentsDTO?
    let reposts: RepostsDTO?
    let copyHistory: [NewsItemDTO]?

    enum CodingKeys: String, CodingKey {
        case type
        case sourceId = "source_id"
        case postId = "post_id"
        case postType = "post_type"
        case date
        case text
        case attachments
        case likes
        case comments
        case reposts
        case copyHistory = "copy_history"
    }
}
