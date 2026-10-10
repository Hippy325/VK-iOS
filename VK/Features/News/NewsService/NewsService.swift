//
//  NewsService.swift
//  VK
//
//  Created by Tigran Garibyan on 05.10.2026.
//

import Foundation

final class NewsService {

    // MARK: - Private properties

    private let apiClient: IAPIClient
    private let token: String
    private let count: Int

    // MARK: - Init

    init(
        apiClient: IAPIClient,
        token: String,
        count: Int = 20
    ) {
        self.apiClient = apiClient
        self.token = token
        self.count = count
    }
}

// MARK: - Extension INewsService

extension NewsService: INewsService {
    func fetchNews(
        nextFrom: String?,
        completion: @escaping (Result<NewsPage, Error>) -> Void
    ) {
        let endpoint = NewsFeedEndpoint(
            token: token,
            startFrom: nextFrom,
            count: count
        )

        apiClient.request(
            endpoint,
            responseType: NewsFeedResponseDTO.self
        ) { result in
            switch result {
            case .success(let dto):
                completion(.success(NewsFeedMapper.makePage(from: dto)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
