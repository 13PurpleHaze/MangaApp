//
//  NavBarReusableView.swift
//  MangaApp
//
//  Created by Никита Новицкий on 22.08.2025.
//

import UIKit

class NavBarReusableView: UICollectionReusableView {
    static let reuseIdentifier = "NavBarReusableView"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(backButton)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(likeButton)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(title: String, onGoBackAction: @escaping () -> Void, onLikeAction: @escaping () -> Void) {
        titleLabel.text = title
        backButton.addAction(UIAction { _ in
            onGoBackAction()
        }, for: .touchUpInside)
        likeButton.addAction(UIAction { _ in
            onLikeAction()
        }, for: .touchUpInside)
    }
}
