//
//  Metrics.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import CoreGraphics

enum Metrics {
    static let cornerRadius: CGFloat = 8

    enum Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }

    enum Inset {
        /// Отступ таблицы от краёв экрана.
        static let screen: CGFloat = 8
        /// Внутренние отступы карточки поста.
        static let horizontal: CGFloat = 12
        static let vertical: CGFloat = 12
        /// Отступ карточки внутри ячейки, чтобы тень не обрезалась таблицей.
        static let cardHorizontal: CGFloat = 4
        /// Расстояние между карточками постов (делится поровну между соседними ячейками).
        static let postSpacing: CGFloat = 16
        static let cardVertical: CGFloat = postSpacing / 2
    }

    enum Size {
        static let avatar: CGFloat = 40
        static let avatarSmall: CGFloat = 28
    }
}
