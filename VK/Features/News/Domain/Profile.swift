//
//  Profile.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import Foundation

struct Profile: Hashable {
    let id: Int
    let name: String
    let screenName: String?
    let avatarURL: URL?
    let isGroup: Bool
}
