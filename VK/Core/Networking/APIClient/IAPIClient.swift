//
//  IAPIClient.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

protocol IAPIClient: AnyObject {
    func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}
