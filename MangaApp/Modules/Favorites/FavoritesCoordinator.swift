//
//  FavoritesCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 09.08.2025.
//

class FavoritesCoordinator: BaseCoordinator {
    override func start() {
        let vc = resolver.resolve(FavoritesViewController.self)!
        navigationController.pushViewController(vc, animated: true)
    }
}
