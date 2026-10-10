//
//  NewsInteractor.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import Foundation

final class NewsInteractor {

    // MARK: - Public properties

    weak var output: INewsInteractorOutput?

    // MARK: - Private properties

    private let service: INewsService
    private var nextFrom: String?
    private var hasMore = true
    private var isLoading = false

    // MARK: - Init

    init(service: INewsService) {
        self.service = service
    }

    // MARK: - Private method

    private func load(nextFrom: String?) {
        guard !isLoading else { return }
        isLoading = true

        service.fetchNews(nextFrom: nextFrom) { [weak self] result in
            guard let self else { return }

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

// MARK: - Extension INewsInteractor

extension NewsInteractor: INewsInteractor {
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
