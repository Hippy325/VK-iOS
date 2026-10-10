//
//  IconTextButton.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

final class IconTextButton: UIButton {

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
        icon: UIImage?,
        title: String
    ) {
        configuration?.image = icon
        configuration?.title = title
    }

    // MARK: - Private method

    private func setup() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = Metrics.Spacing.tiny
        config.contentInsets = .zero
        config.baseForegroundColor = AppColor.secondaryText
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = AppFont.action
            return outgoing
        }
        configuration = config
    }
}
