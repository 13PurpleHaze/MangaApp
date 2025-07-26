//
//  Banner.swift
//  MangaApp
//
//  Created by Никита Новицкий on 07.08.2025.
//

import UIKit

class Banner {
    private var container: UIView!

    func show(in view: UIView, title: String, text: String, imagePath: String, reteryAction: (() -> Void)? = nil) {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        titleLabel.textAlignment = .center
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = .preferredFont(forTextStyle: .body)
        textLabel.textAlignment = .center
        
        // TODO: Подобрать изображение или создать свое
        let image = UIImageView(image: UIImage(named: imagePath))
        image.contentMode = .scaleAspectFit
        
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        container = UIView()
        
        container.alpha = 0
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container!)
        container.backgroundColor = .clear
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.container.alpha = 1
        }
        
        if let reteryAction = reteryAction {
            let button = UIButton()
            button.addAction(UIAction { _ in
                reteryAction()
            }, for: .touchUpInside)
            button.configuration = .plain()
            button.setTitle("Retery again".localizable(), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)
        }
    }
    
    func showError(in view: UIView, reteryAction: @escaping () -> Void) {
        show(in: view, title: "Error occurred", text: "Please try again later", imagePath: "error", reteryAction: reteryAction)
    }
    
    func showEmptyData(in view: UIView, reteryAction: @escaping () -> Void) {
        show(in: view, title: "Has no data", text: "Please try again later", imagePath: "empty-data", reteryAction: reteryAction)
    }
    
    func showNotImplementedYet(in view: UIView) {
        show(in: view, title: "Sorry(((", text: "Feature not implemented yet", imagePath: "not-implemented-yet")
    }
    
    func hide() {
        if container != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.container.alpha = 0
            }) { _ in
                self.container?.removeFromSuperview()
                self.container = nil
            }
        }
    }
}
