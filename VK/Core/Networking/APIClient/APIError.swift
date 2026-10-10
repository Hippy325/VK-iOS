//
//  APIError.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

enum APIError: Error {
    /// Не удалось собрать URL из компонентов эндпоинта.
    case invalidURL
    /// Сервер вернул пустой ответ.
    case noData
    /// Ошибка кодирования тела запроса.
    case encoding(Error)
    /// Ответ не совпал с ожидаемой структурой.
    case decoding(Error)
    /// Транспортная ошибка URLSession: нет сети, таймаут, отмена.
    case transport(Error)
    /// HTTP-статус вне диапазона 2xx.
    case http(statusCode: Int)
    /// Ошибка уровня VK API (`error.error_code` / `error_msg`).
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
