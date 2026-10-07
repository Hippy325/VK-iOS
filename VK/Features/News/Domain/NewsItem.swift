//
//  NewsItem.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import Foundation

struct NewsItem: Hashable {
    let id: Int
    let author: Profile
    let date: Date
    let text: String
    let attachments: [Attachment]
    let likes: Likes
    let reposts: Reposts
}

extension NewsItem {
    var photos: [Photo] {
        attachments.compactMap { attachment in
            guard case .photo(let photo) = attachment else { return nil }
            return photo
        }
    }
}

struct Likes: Hashable {
    let count: Int
    let userLikes: Bool
}

struct Reposts: Hashable {
    let count: Int
    let userReposted: Bool
}
