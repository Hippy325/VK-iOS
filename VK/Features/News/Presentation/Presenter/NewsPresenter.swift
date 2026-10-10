//
//  NewsPresenter.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import Foundation

final class NewsPresenter: INewsPresenter {

    weak var view: INewsView?
    var interactor: INewsInteractor?
    var router: INewsRouter?

    /// Источник правды уровня экрана: накопленные посты.
    private var items: [NewsItem] = []

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
