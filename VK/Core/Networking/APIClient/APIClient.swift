//
//  APIClient.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

final class APIClient {

    // MARK: - Public properties

    static let shared = APIClient()

    // MARK: - Private properties

    private let session: URLSession
    private let decoder: JSONDecoder

    // MARK: - Init

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: - Private method

    private func makeURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path

        if !endpoint.query.isEmpty {
            components.queryItems = endpoint.query.map {
                URLQueryItem(
                    name: $0.key,
                    value: $0.value
                )
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

    private func handle<T: Decodable>(
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

        if let vkError = try? decoder.decode(
            VKErrorResponse.self,
            from: data
        ) {
            let apiError = APIError.api(
                code: vkError.error.code,
                message: vkError.error.message
            )
            return .failure(apiError)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.http(statusCode: httpResponse.statusCode))
        }

        if let envelope = try? decoder.decode(
            VKResponseEnvelope<T>.self,
            from: data
        ) {
            return .success(envelope.response)
        }

        do {
            let value = try decoder.decode(
                T.self,
                from: data
            )
            return .success(value)
        } catch {
            return .failure(.decoding(error))
        }
    }
}

// MARK: - Extension IAPIClient

extension APIClient: IAPIClient {
    func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        responseType: T.Type,
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
            let result = self.handle(
                data: data,
                response: response,
                error: error
            ) as Result<T, APIError>
            completion(result)
        }.resume()
    }
}

private struct VKErrorResponse: Decodable {
    let error: VKError
}

private struct VKError: Decodable {
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case message = "error_msg"
    }
}

private struct VKResponseEnvelope<T: Decodable>: Decodable {
    let response: T
}
