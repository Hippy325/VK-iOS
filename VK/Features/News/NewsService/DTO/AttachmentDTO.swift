//
//  AttachmentDTO.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

/// Вложение записи. Пока поддерживаем только фото,
/// остальные типы (`video`, `link`, ...) добавляются по мере необходимости.
struct AttachmentDTO: Decodable {
    let type: String
    let photo: PhotoDTO?
}
