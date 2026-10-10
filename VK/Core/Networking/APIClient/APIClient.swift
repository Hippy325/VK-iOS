//
//  APIClient.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

final class APIClient: IAPIClient {

    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        let request: URLRequest
        do {
            request = try makeURLRequest(from: endpoint)
        } catch let error as APIError {
            completion(.failure(error))
            return
        } catch {
            completion(.failure(.invalidURL))
            return
        }

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            completion(self.handle(data: data, response: response, error: error))
        }.resume()
    }
}

private extension APIClient {
    func makeURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path

        if !endpoint.query.isEmpty {
            components.queryItems = endpoint.query.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        return request
    }

    func handle<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Result<T, APIError> {
        if let error {
            return .failure(.transport(error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noData)
        }

        guard let data, !data.isEmpty else {
            return .failure(.noData)
        }

        // VK может вернуть ошибку метода с HTTP 200 — разбираем её до статуса.
        if let vkError = try? decoder.decode(VKErrorResponse.self, from: data) {
            return .failure(.api(code: vkError.error.code, message: vkError.error.message))
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.http(statusCode: httpResponse.statusCode))
        }

        // VK заворачивает успешный ответ в {"response": {...}}.
        if let envelope = try? decoder.decode(VKResponseEnvelope<T>.self, from: data) {
            return .success(envelope.response)
        }

        do {
            return .success(try decoder.decode(T.self, from: data))
        } catch {
            return .failure(.decoding(error))
        }
    }
}

private struct VKErrorResponse: Decodable {
    struct VKError: Decodable {
        let code: Int
        let message: String

        enum CodingKeys: String, CodingKey {
            case code = "error_code"
            case message = "error_msg"
        }
    }

    let error: VKError
}

private struct VKResponseEnvelope<T: Decodable>: Decodable {
    let response: T
}
