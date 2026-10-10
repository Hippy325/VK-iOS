//
//  APIError.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case encoding(Error)
    case decoding(Error)
    case transport(Error)
    case http(statusCode: Int)
    case api(code: Int, message: String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный адрес запроса."
        case .noData:
            return "Сервер вернул пустой ответ."
        case .encoding(let error):
            return "Не удалось закодировать запрос: \(error.localizedDescription)"
        case .decoding:
            return "Не удалось разобрать ответ сервера."
        case .transport(let error):
            return error.localizedDescription
        case .http(let statusCode):
            return "Ошибка сервера (код \(statusCode))."
        case .api(_, let message):
            return message
        }
    }
}
