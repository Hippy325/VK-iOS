//
//  NewsService.swift
//  VK
//
//  Created by Tigran Garibyan on 05.10.2026.
//

import Foundation

/// Реальная реализация источника новостей через VK API.
final class NewsService: INewsService {

    private let apiClient: IAPIClient
    private let token: String
    private let count: Int

    init(apiClient: IAPIClient, token: String, count: Int = 20) {
        self.apiClient = apiClient
        self.token = token
        self.count = count
    }

    func fetchNews(nextFrom: String?, completion: @escaping (Result<NewsPage, Error>) -> Void) {
        let endpoint = NewsFeedEndpoint(token: token, startFrom: nextFrom, count: count)

        apiClient.request(endpoint) { (result: Result<NewsFeedResponseDTO, APIError>) in
            switch result {
            case .success(let dto):
                completion(.success(NewsFeedMapper.makePage(from: dto)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
