//
//  NewsServiceMock.swift
//  VK
//
//  Created by Tigran Garibyan on 05.10.2026.
//

import Foundation

/// Мок источника новостей: отдаёт страницы с задержкой, имитируя сеть.
final class NewsServiceMock: INewsService {

    private static let pageSize = 10
    private static let totalItems = 45
    private static let delay: TimeInterval = 1

    private let authors: [Profile] = [
        Profile(id: 1, name: "Иван Петров", screenName: "ivan_petrov", avatarURL: nil, isGroup: false),
        Profile(id: -101, name: "Мир IT", screenName: "it_world", avatarURL: nil, isGroup: true),
        Profile(id: 2, name: "Анна Смирнова", screenName: "anna_s", avatarURL: nil, isGroup: false),
        Profile(id: -102, name: "Кулинария", screenName: "cooking", avatarURL: nil, isGroup: true),
        Profile(id: 3, name: "Дмитрий Волков", screenName: "dvolkov", avatarURL: nil, isGroup: false)
    ]

    private let texts: [String] = [
        "Сегодня отличный день, чтобы начать что-то новое!",
        "Делюсь фотографиями с выходных.",
        "Как вам такой закат?",
        "Наконец-то закончил проект. Спасибо всем за поддержку!",
        "Попробовал новый рецепт — получилось вкусно.",
        "Пара кадров с прогулки по городу.",
        "Всем доброго утра!",
        "Кто ещё не видел — обязательно посмотрите."
    ]

    func fetchNews(nextFrom: String?, completion: @escaping (Result<NewsPage, Error>) -> Void) {
        let startIndex = nextFrom.flatMap(Int.init) ?? 0
        let endIndex = min(startIndex + Self.pageSize, Self.totalItems)
        let items = (startIndex..<endIndex).map(makeItem(at:))
        let next = endIndex < Self.totalItems ? String(endIndex) : nil

        DispatchQueue.main.asyncAfter(deadline: .now() + Self.delay) {
            completion(.success(NewsPage(items: items, nextFrom: next)))
        }
    }
}

private extension NewsServiceMock {
    func makeItem(at index: Int) -> NewsItem {
        let author = authors[index % authors.count]
        let photoCount = [0, 1, 2, 3, 4][index % 5]
        let photos = (0..<photoCount).map(makePhoto(seed:))

        return NewsItem(
            id: index,
            author: author,
            date: Date().addingTimeInterval(-Double(index) * 3_600),
            text: texts[index % texts.count],
            attachments: photos.map(Attachment.photo),
            likes: Likes(count: (index * 7) % 120, userLikes: index % 3 == 0),
            comments: Comments(count: (index * 3) % 40),
            reposts: Reposts(count: (index * 2) % 25, userReposted: false)
        )
    }

    /// Разные пропорции, чтобы проверить вёрстку сетки.
    func makePhoto(seed: Int) -> Photo {
        switch seed % 3 {
        case 0:
            return Photo(url: nil, width: 1080, height: 1440) // портрет
        case 1:
            return Photo(url: nil, width: 1600, height: 900)  // ландшафт
        default:
            return Photo(url: nil, width: 1000, height: 1000) // квадрат
        }
    }
}
