//
//  UITableView+LoadingFooter.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

extension UITableView {
    func setLoadingFooter(_ isLoading: Bool) {
        guard isLoading else {
            tableFooterView = nil
            return
        }

        let footer = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 48))
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        footer.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
        ])

        loadingView.startAnimating()
        tableFooterView = footer
    }
}
