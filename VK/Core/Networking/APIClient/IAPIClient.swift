//
//  IAPIClient.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

protocol IAPIClient: AnyObject {
    /// Выполняет запрос по `Endpoint`.
    /// - Note: `completion` вызывается не на главном потоке — переключаться на main должен вызывающий.
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}
