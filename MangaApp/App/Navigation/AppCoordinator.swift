//
//  AppCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 09.08.2025.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    override func start() {
        let tabBarController = UITabBarController()
        navigationController.viewControllers = [tabBarController]
        navigationController.isNavigationBarHidden = true

        let coordinators = [
            HomeCoordinator(navigationController: UINavigationController(), resolver: resolver),
            MangaListCoordinator(navigationController: UINavigationController(), resolver: resolver),
            FavoritesCoordinator(navigationController: UINavigationController(), resolver: resolver),
        ]

        for (index, coordinator) in coordinators.enumerated() {
            addChildCoordinator(coordinator)
            coordinator.start()
            switch index {
            case 0:
                coordinator.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
            case 1:
                coordinator.navigationController.tabBarItem = UITabBarItem(title: "Manga", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
            case 2:
                coordinator.navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
            default:
                continue
            }
        }

        tabBarController.viewControllers = coordinators.map { $0.navigationController }
    }
}
