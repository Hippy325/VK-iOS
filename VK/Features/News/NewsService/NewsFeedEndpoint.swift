//
//  NewsFeedEndpoint.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

struct NewsFeedEndpoint: Endpoint {
    let token: String
    let startFrom: String?
    let count: Int

    var path: String { "/method/newsfeed.get" }

    var query: [String: String] {
        var query: [String: String] = [
            "access_token": token,
            "v": "5.199",
            "filters": "post",
            "count": String(count)
        ]
        if let startFrom {
            query["start_from"] = startFrom
        }
        return query
    }
}
