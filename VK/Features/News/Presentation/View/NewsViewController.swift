//
//  NewsViewController.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import UIKit

final class NewsViewController: UIViewController {

    private let presenter: INewsPresenter
    private var items: [NewsItem] = []

    private lazy var titleView = UserTitleView()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            NewsTableViewCell.self,
            forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier
        )
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 240
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    init(presenter: INewsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presenter.didLoad()
    }

    private func setupUI() {
        view.backgroundColor = AppColor.background
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.Inset.screen),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.Inset.screen),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.background
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false

        // Системное плавное скрытие панели при скролле вниз.
        navigationController?.hidesBarsOnSwipe = true

        titleView.configure(name: "Пользователь", avatarURL: nil)
        navigationItem.titleView = titleView
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension NewsViewController: INewsView {
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? NewsTableViewCell else { return UITableViewCell() }
        cell.configure(items[indexPath.row])
        return cell
    }
}
