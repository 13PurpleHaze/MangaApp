//
//  ChapterCell.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

import UIKit

class ChapterCell: UICollectionViewCell {
    static let reuseIdentifier = "ChapterCell"

    private let titleLabel = UILabel()
    private let pagesLabel = UILabel()
    private let languageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, language: String, pages: String) {
        titleLabel.text = title
        languageLabel.text = "language: \(language)"
        pagesLabel.text = "pages: \(pages)".localizable()
    }

    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.alignment = .bottom
        contentView.addSubview(stackView)

        titleLabel.font = .preferredFont(forTextStyle: .title3)
        languageLabel.textColor = .secondaryLabel
        languageLabel.font = .preferredFont(forTextStyle: .caption1)
        pagesLabel.textColor = .secondaryLabel
        pagesLabel.font = .preferredFont(forTextStyle: .caption1)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(languageLabel)
        stackView.addArrangedSubview(pagesLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ])

        // Bottom line
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0, y: contentView.frame.size.height, width: contentView.frame.size.width - 32, height: 1)
        stackView.layer.addSublayer(layer)
    }
}
