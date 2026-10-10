//
//  NewsAssembly.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import UIKit

final class NewsAssembly: INewsAssembly {
    func assembly() -> UIViewController {
        let interactor = NewsInteractor(service: makeService())
        let presenter = NewsPresenter()
        let router = NewsRouter()
        let view = NewsViewController(presenter: presenter)

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter

        return view
    }
}

private extension NewsAssembly {
    /// Пока не задан токен VK — работаем на моке, чтобы приложение запускалось.
    func makeService() -> INewsService {
        let token = AppConfig.vkAccessToken
        guard !token.isEmpty else {
            return NewsServiceMock()
        }
        return NewsService(apiClient: APIClient.shared, token: token)
    }
}
