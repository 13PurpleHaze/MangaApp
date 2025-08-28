//
//  ImageCell.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    private let imageView = UIImageView()
    private let minimalImageView = UIImageView()
    private let titleLabel = UILabel()
    private let gradientLayer = CAGradientLayer()

    static let minHeight = CGFloat(130)
    static let defaultHeight = CGFloat(400)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)

        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // contentView.addSubview(titleLabel)

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.withAlphaComponent(0.7).cgColor,
            UIColor.systemBackground.withAlphaComponent(1).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.6, 1.0]
        imageView.layer.addSublayer(gradientLayer)

        minimalImageView.contentMode = .scaleAspectFill
        minimalImageView.clipsToBounds = true
        minimalImageView.layer.cornerRadius = 16

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.addArrangedSubview(minimalImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        minimalImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            minimalImageView.widthAnchor.constraint(equalToConstant: 100),
            minimalImageView.heightAnchor.constraint(equalToConstant: 100),

            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    func configure(image: String, title: String) {
        let url = URL(string: image)!
        imageView.kf.setImage(with: url)
        minimalImageView.kf.setImage(with: url)
        titleLabel.text = title
    }

    func handleScroll(offsetY: CGFloat) {
        if offsetY <= 0 {
            let scale = 1 + abs(offsetY) / 200
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.commit()
    }
}
