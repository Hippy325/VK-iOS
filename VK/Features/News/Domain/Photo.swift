//
//  Photo.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import Foundation

struct Photo: Hashable {
    let url: URL?
    let width: Int
    let height: Int

    var aspectRatio: CGFloat {
        height == 0 ? 1 : CGFloat(width) / CGFloat(height)
    }
}
