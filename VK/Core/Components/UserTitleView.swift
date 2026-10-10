//
//  UserTitleView.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

final class UserTitleView: UIView {

    // MARK: - View

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let stack = UIStackView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    func configure(
        name: String,
        avatarURL: URL?
    ) {
        nameLabel.text = name
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
    }

    // MARK: - Private method

    private func setup() {
        avatarImageView.backgroundColor = AppColor.placeholder
        avatarImageView.tintColor = AppColor.secondaryText
        avatarImageView.contentMode = .center
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = Metrics.Size.avatarSmall / 2
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: Metrics.Size.avatarSmall),
            avatarImageView.heightAnchor.constraint(equalToConstant: Metrics.Size.avatarSmall),
        ])

        nameLabel.font = AppFont.authorName
        nameLabel.textColor = AppColor.primaryText

        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Metrics.Spacing.small
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(avatarImageView)
        stack.addArrangedSubview(nameLabel)
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
