//
//  AttachmentDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

nonisolated struct AttachmentDTO: Decodable {
    let type: String
    let photo: PhotoDTO?
}
