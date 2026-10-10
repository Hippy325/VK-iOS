//
//  INewsInteractor.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

protocol INewsInteractor: AnyObject {
    var canLoadMore: Bool { get }

    func loadFirstPage()
    func loadNextPage()
}
