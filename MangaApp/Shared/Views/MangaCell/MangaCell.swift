//
//  MangaCell.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

import UIKit
import Kingfisher

class MangaCell: UICollectionViewCell {
    static let reuseIdentifier = "MangaCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValues(title: String, imageURL: String?) {
        titleLabel.text = title
        let url = URL(string: imageURL!)!
        imageView.kf.indicatorType = .activity
        DispatchQueue.main.async {
            self.imageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(0.2)),
                    .retryStrategy(DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(3)))
                ]
            )
        }
        imageView.kf.indicatorType = .activity
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
    }
}
