//
//  Endpoint.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Описание запроса к API. Конкретные эндпоинты — внутренняя деталь сервисов.
protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [String: String] { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "api.vk.ru" }
    var method: HTTPMethod { .get }
    var query: [String: String] { [:] }
    var headers: [String: String] { ["Accept": "application/json"] }
    var body: Data? { nil }
}
