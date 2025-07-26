//
//  ChaperImageCell.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

import UIKit
import Kingfisher

class ChapterImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ChapterImageCell"
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(imageURL: String) {
        let url = URL(string: imageURL)!
        imageView.kf.indicatorType = .activity
        DispatchQueue.main.async {
            self.imageView.kf.setImage(
                with: url,
               //placeholder: UIImage(named: "placeholder"),
                options: [
                    
                    .transition(.fade(0.2)),
                    .retryStrategy(DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(3)))
                ]
            )
        }
        
        imageView.kf.indicatorType = .activity
    }
}
