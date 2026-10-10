//
//  INewsService.swift
//  VK
//
//  Created by Tigran Garibyan on 05.10.2026.
//

import Foundation

protocol INewsService {
    /// Загружает страницу новостей. `nextFrom == nil` — первая страница.
    func fetchNews(nextFrom: String?, completion: @escaping (Result<NewsPage, Error>) -> Void)
}
