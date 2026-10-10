//
//  NewsViewController.swift
//  VK
//
//  Created by Tigran Garibyan on 06.10.2026.
//

import UIKit

final class NewsViewController: UIViewController {

    // MARK: - View

    private lazy var titleView = UserTitleView()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(
            NewsTableViewCell.self,
            forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier
        )
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 240
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()

    // MARK: - Private properties

    private let presenter: INewsPresenter
    private var items: [NewsItem] = []

    // MARK: - Init

    init(presenter: INewsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presenter.didLoad()
    }

    // MARK: - Private method

    @objc private func handleRefresh() {
        presenter.didPullToRefresh()
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

        navigationController?.hidesBarsOnSwipe = true

        titleView.configure(
            name: "Пользователь",
            avatarURL: nil
        )
        navigationItem.titleView = titleView
        navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - Extension INewsView

extension NewsViewController: INewsView {
    func display(_ state: NewsViewState) {
        refreshControl.endRefreshing()

        switch state {
        case .loading:
            break
        case .loaded(let items):
            self.items = items
            tableView.reloadData()
        case .empty:
            items.removeAll()
            tableView.reloadData()
        case .error(let message):
            presentError(message)
        }
    }

    func setLoadingMore(_ isLoading: Bool) {
        tableView.setLoadingFooter(isLoading)
    }
}

// MARK: - Extension UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
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

// MARK: - Extension UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard indexPath.row == items.count - 1 else { return }
        presenter.didReachEnd()
    }
}

// MARK: - Extension UITableViewDataSourcePrefetching

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(
        _ tableView: UITableView,
        prefetchRowsAt indexPaths: [IndexPath]
    ) {
        guard let maxRow = indexPaths.map(\.row).max(),
              maxRow >= items.count - 2 else { return }
        presenter.didReachEnd()
    }
}
