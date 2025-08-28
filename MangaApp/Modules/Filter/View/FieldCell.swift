//
//  FieldCell.swift
//  MangaApp
//
//  Created by Никита Новицкий on 04.08.2025.
//

import UIKit

class FieldCell: UICollectionViewCell {
    static let reuseIdentifier = "FieldCell"
    private let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                button.configuration?.baseBackgroundColor = .systemBlue
                button.configuration?.baseForegroundColor = .white
            } else {
                button.configuration?.baseBackgroundColor = .systemGray5
                button.configuration?.baseForegroundColor = .secondaryLabel
            }
        }
    }

    func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }

    private func configure() {
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.configuration = .gray()
        button.configuration?.baseBackgroundColor = .systemGray5
        button.configuration?.baseForegroundColor = .secondaryLabel
        button.isUserInteractionEnabled = false

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
}
