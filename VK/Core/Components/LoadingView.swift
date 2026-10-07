//
//  LoadingView.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

/// Общий индикатор загрузки.
final class LoadingView: UIView {

    private let indicator = UIActivityIndicatorView(style: .medium)

    var isAnimating: Bool {
        indicator.isAnimating
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        indicator.startAnimating()
    }

    func stopAnimating() {
        indicator.stopAnimating()
    }
}

private extension LoadingView {
    func setup() {
        indicator.color = AppColor.secondaryText
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
