//
//  NewsAssembly.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import UIKit

final class NewsAssembly: INewsAssembly {
    func assembly() -> UIViewController {
        let service = NewsServiceMock()
        let interactor = NewsInteractor(service: service)
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
