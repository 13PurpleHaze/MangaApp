//
//  BackgroundLoader.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

import UIKit

class BackgroundLoader {
    private var container = UIView()
    
    func show(in view: UIView) {
        container.alpha = 0
        container.translatesAutoresizingMaskIntoConstraints = false
        container.bounds = view.bounds
        container.backgroundColor = .clear
        view.addSubview(container)
        
        let indicator = UIActivityIndicatorView(style: .large)
        container.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        indicator.startAnimating()
        
        UIView.animate(withDuration: 0.3) {
            self.container.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.container.alpha = 0
        }) { _ in
            //self.container.removeFromSuperview()
        }
    }
}
