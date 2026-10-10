//
//  NewsInteractor.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import Foundation

final class NewsInteractor: INewsInteractor {

    weak var output: INewsInteractorOutput?

    private let service: INewsService
    private var nextFrom: String?
    private var hasMore = true
    private var isLoading = false

    init(service: INewsService) {
        self.service = service
    }

    var canLoadMore: Bool {
        hasMore && !isLoading
    }

    func loadFirstPage() {
        nextFrom = nil
        hasMore = true
        load(nextFrom: nil)
    }

    func loadNextPage() {
        guard canLoadMore else { return }
        load(nextFrom: nextFrom)
    }
}

private extension NewsInteractor {
    func load(nextFrom: String?) {
        guard !isLoading else { return }
        isLoading = true

        service.fetchNews(nextFrom: nextFrom) { [weak self] result in
            guard let self else { return }

            // Сервис может ответить не на главном потоке — приводим к нему здесь.
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let page):
                    self.nextFrom = page.nextFrom
                    self.hasMore = page.nextFrom != nil
                    self.output?.didReceive(page)
                case .failure(let error):
                    self.output?.didFail(with: error)
                }
            }
        }
    }
}
