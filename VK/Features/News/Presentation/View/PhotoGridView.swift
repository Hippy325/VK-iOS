//
//  PhotoGridView.swift
//  VK
//
//  Created by Tigran Garibyan on 07.10.2026.
//

import UIKit

/// Показывает вложения-фотографии поста:
/// одна — во всю ширину с сохранением пропорций, несколько — сеткой 2 в ряд.
final class PhotoGridView: UIView {

    private static let maxVisiblePhotos = 4

    private let rowsStack = UIStackView()
    private var singlePhotoAspectConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with photos: [Photo]) {
        reset()

        guard !photos.isEmpty else {
            isHidden = true
            return
        }
        isHidden = false

        if photos.count == 1 {
            configureSinglePhoto(photos[0])
        } else {
            configureGrid(photos: Array(photos.prefix(Self.maxVisiblePhotos)))
        }
    }
}

private extension PhotoGridView {
    func setup() {
        rowsStack.axis = .vertical
        rowsStack.spacing = Metrics.Spacing.tiny
        rowsStack.alignment = .fill
        rowsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rowsStack)

        NSLayoutConstraint.activate([
            rowsStack.topAnchor.constraint(equalTo: topAnchor),
            rowsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rowsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            rowsStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func reset() {
        singlePhotoAspectConstraint?.isActive = false
        singlePhotoAspectConstraint = nil

        rowsStack.arrangedSubviews.forEach {
            rowsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    func configureSinglePhoto(_ photo: Photo) {
        let imageView = makeImageView()
        rowsStack.addArrangedSubview(imageView)

        let ratio = 1 / max(photo.aspectRatio, 0.01)
        let constraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio)
        constraint.isActive = true
        singlePhotoAspectConstraint = constraint
    }

    func configureGrid(photos: [Photo]) {
        var index = 0
        while index < photos.count {
            let row = makeRow()

            for column in 0..<2 {
                if index + column < photos.count {
                    let imageView = makeImageView()
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
                    row.addArrangedSubview(imageView)
                } else {
                    row.addArrangedSubview(UIView())
                }
            }

            rowsStack.addArrangedSubview(row)
            index += 2
        }
    }

    func makeRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = Metrics.Spacing.tiny
        row.distribution = .fillEqually
        return row
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.placeholder
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.cornerRadius
        // Загрузка картинки по url — отдельная задача.
        return imageView
    }
}
