//
//  AppConfig.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

enum AppConfig {
    /// Токен доступа VK. Пустая строка, если не задан.
    /// Значение берётся из `Secrets.plist` (в `.gitignore`).
    static var vkAccessToken: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let token = plist["vkAccessToken"] as? String
        else {
            return ""
        }
        return token
    }
}
