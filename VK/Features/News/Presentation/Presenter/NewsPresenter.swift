//
//  NewsPresenter.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import Foundation

final class NewsPresenter {

    // MARK: - Public properties

    weak var view: INewsView?
    var interactor: INewsInteractor?
    var router: INewsRouter?

    // MARK: - Private properties

    private var items: [NewsItem] = []
}

// MARK: - Extension INewsPresenter

extension NewsPresenter: INewsPresenter {
    func didLoad() {
        view?.display(.loading)
        interactor?.loadFirstPage()
    }

    func didPullToRefresh() {
        items.removeAll()
        interactor?.loadFirstPage()
    }

    func didReachEnd() {
        guard interactor?.canLoadMore == true else { return }
        view?.setLoadingMore(true)
        interactor?.loadNextPage()
    }
}

// MARK: - Extension INewsInteractorOutput

extension NewsPresenter: INewsInteractorOutput {
    func didReceive(_ page: NewsPage) {
        items.append(contentsOf: page.items)
        view?.setLoadingMore(false)
        view?.display(items.isEmpty ? .empty : .loaded(items))
    }

    func didFail(with error: Error) {
        view?.setLoadingMore(false)
        view?.display(.error(error.localizedDescription))
    }
}
