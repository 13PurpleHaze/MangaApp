//
//  ChaptersLinkCell.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

import UIKit

class ChaptersLinkCell: UICollectionViewCell {
    static let reuseIdentifier = "ChaptersLinkCell"
    private let titleLabel = UILabel()
    private let linkImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        titleLabel.font = .preferredFont(forTextStyle: .body)
        stackView.addArrangedSubview(titleLabel)

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        linkImageView.image = image
        stackView.addArrangedSubview(linkImageView)
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
