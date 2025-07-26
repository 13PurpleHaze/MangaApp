//
//  MangaDetailAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 13.08.2025.
//

import UIKit
import Swinject

class MangaDetailAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(MangaDetailViewController.self) { r in
            let presenter = MangaDetailPresenter(mangaService: r.resolve(MangaServiceProtocol.self)!)
            let vc = MangaDetailViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }
    }
}
