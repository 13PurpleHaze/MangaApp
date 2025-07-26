//
//  MainTabBarController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configure() {
        
    }
}
