//
//  LoadingView.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

final class LoadingView: UIView {

    // MARK: - View

    private let indicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Public properties

    var isAnimating: Bool {
        indicator.isAnimating
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    func startAnimating() {
        indicator.startAnimating()
    }

    func stopAnimating() {
        indicator.stopAnimating()
    }

    // MARK: - Private method

    private func setup() {
        indicator.color = AppColor.secondaryText
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
