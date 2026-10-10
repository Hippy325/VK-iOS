//
//  INewsView.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

protocol INewsView: AnyObject {
    func display(_ state: NewsViewState)
    func setLoadingMore(_ isLoading: Bool)
}
