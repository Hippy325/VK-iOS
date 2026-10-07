//
//  NewsAssembly.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import UIKit

final class NewsAssembly: INewsAssembly {
    func assembly() -> UIViewController {
        let presenter = NewsPresenter()
        return NewsViewController(presenter: presenter)
    }
}
