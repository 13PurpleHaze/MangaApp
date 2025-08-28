//
//  FavoritesAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Swinject
import UIKit

class FavoritesAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(FavoritesViewController.self) { _ in
            FavoritesViewController()
        }
    }
}
