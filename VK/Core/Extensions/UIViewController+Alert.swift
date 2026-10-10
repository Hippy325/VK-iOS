//
//  UIViewController+Alert.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

extension UIViewController {
    func presentError(
        _ message: String,
        title: String = "Не удалось загрузить"
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
