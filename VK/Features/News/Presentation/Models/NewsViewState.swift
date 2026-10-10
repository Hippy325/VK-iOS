//
//  NewsViewState.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

enum NewsViewState {
    case loading
    case loaded([NewsItem])
    case empty
    case error(String)
}
