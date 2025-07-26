//
//  HomeAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Swinject

class HomeAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(HomeViewController.self) { r in
            let presenter = HomePresenter(mangaService: r.resolve(MangaServiceProtocol.self)!)
            let vc = HomeViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }
    }
}
