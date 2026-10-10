//
//  INewsInteractorOutput.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import Foundation

protocol INewsInteractorOutput: AnyObject {
    func didReceive(_ page: NewsPage)
    func didFail(with error: Error)
}
