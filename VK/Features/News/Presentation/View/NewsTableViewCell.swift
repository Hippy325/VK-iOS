//
//  NewsTableViewCell.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: NewsTableViewCell.self)

    // Карточка: даёт радиус и тень
    private let cardView = UIView()

    // Секция 1: автор
    private lazy var authorAvatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.placeholder
        imageView.tintColor = AppColor.secondaryText
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.Size.avatar / 2
        return imageView
    }()

    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.authorName
        label.textColor = AppColor.primaryText
        label.numberOfLines = 1
        return label
    }()

    // Секция 2: медиа и описание
    private let photoGridView = PhotoGridView()

    private lazy var postTextLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.primaryText
        label.numberOfLines = 0
        return label
    }()

    // Секция 3: действия и дата
    private let likeButton = IconTextButton()
    private let commentButton = IconTextButton()
    private let repostButton = IconTextButton()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.secondaryText
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let headerStack = UIStackView()
    private let contentStack = UIStackView()
    private let footerStack = UIStackView()
    private lazy var rootStack = UIStackView(arrangedSubviews: [headerStack, contentStack, footerStack])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatarView.image = nil
        postTextLabel.text = nil
        photoGridView.configure(with: [])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: Metrics.cornerRadius
        ).cgPath
    }

    func configure(_ newsItem: NewsItem) {
        authorNameLabel.text = newsItem.author.name
        authorAvatarView.image = UIImage(systemName: "person.crop.circle.fill")

        photoGridView.configure(with: newsItem.photos)

        postTextLabel.text = newsItem.text
        postTextLabel.isHidden = newsItem.text.isEmpty

        let heartName = newsItem.likes.userLikes ? "heart.fill" : "heart"
        likeButton.configure(icon: UIImage(systemName: heartName), title: "\(newsItem.likes.count)")
        commentButton.configure(icon: UIImage(systemName: "bubble.right"), title: "\(newsItem.comments.count)")
        repostButton.configure(icon: UIImage(systemName: "arrow.2.squarepath"), title: "\(newsItem.reposts.count)")

        dateLabel.text = Self.dateFormatter.localizedString(for: newsItem.date, relativeTo: Date())
    }
}

private extension NewsTableViewCell {
    static let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.unitsStyle = .short
        return formatter
    }()

    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupCard()
        setupHeader()
        setupContent()
        setupFooter()
        setupRoot()
    }

    func setupCard() {
        cardView.backgroundColor = AppColor.card
        cardView.layer.cornerRadius = Metrics.cornerRadius
        cardView.layer.borderWidth = 0.5
        cardView.layer.borderColor = AppColor.cardBorder.cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.Inset.cardVertical),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.Inset.cardHorizontal),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.Inset.cardHorizontal),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.Inset.cardVertical),
        ])
    }

    func setupHeader() {
        authorAvatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorAvatarView.widthAnchor.constraint(equalToConstant: Metrics.Size.avatar),
            authorAvatarView.heightAnchor.constraint(equalToConstant: Metrics.Size.avatar),
        ])

        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = Metrics.Spacing.small
        headerStack.addArrangedSubview(authorAvatarView)
        headerStack.addArrangedSubview(authorNameLabel)
    }

    func setupContent() {
        contentStack.axis = .vertical
        contentStack.spacing = Metrics.Spacing.small
        contentStack.addArrangedSubview(photoGridView)
        contentStack.addArrangedSubview(postTextLabel)
    }

    func setupFooter() {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = Metrics.Spacing.medium
        footerStack.addArrangedSubview(likeButton)
        footerStack.addArrangedSubview(commentButton)
        footerStack.addArrangedSubview(repostButton)
        footerStack.addArrangedSubview(spacer)
        footerStack.addArrangedSubview(dateLabel)
    }

    func setupRoot() {
        rootStack.axis = .vertical
        rootStack.spacing = Metrics.Spacing.tiny
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(rootStack)

        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Metrics.Inset.vertical),
            rootStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Metrics.Inset.horizontal),
            rootStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Metrics.Inset.horizontal),
            rootStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Metrics.Inset.vertical),
        ])
    }
}
