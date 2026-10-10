//
//  AppColor.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

enum AppColor {
    static let background = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.09, alpha: 1) : .white
    }

    static let card = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.16, alpha: 1) : UIColor(white: 0.93, alpha: 1)
    }

    static let cardBorder = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.28, alpha: 1) : UIColor(white: 0.86, alpha: 1)
    }

    static let primaryText = UIColor { trait in
        trait.userInterfaceStyle == .dark ? .white : UIColor(white: 0.05, alpha: 1)
    }

    static let secondaryText = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.70, alpha: 1) : UIColor(white: 0.45, alpha: 1)
    }

    static let separator = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.25, alpha: 1) : UIColor(white: 0.90, alpha: 1)
    }

    static let placeholder = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(white: 0.26, alpha: 1) : UIColor(white: 0.85, alpha: 1)
    }

    static let accent = UIColor(red: 0, green: 0.467, blue: 1, alpha: 1)
}
