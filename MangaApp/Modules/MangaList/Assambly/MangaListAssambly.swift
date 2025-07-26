//
//  MangaListAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Swinject
import UIKit

class MangaListAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(MangaListViewController.self) { r in
            let historyVC = r.resolve(HistoryViewController.self)!
            let presenter = MangaListPresenter(
                mangaService: r.resolve(MangaServiceProtocol.self)!,
                filterService: r.resolve(FilterServiceProtocol.self)!,
                historyService: r.resolve(HistoryServiceProtocol.self)!
            )
            let vc = MangaListViewController(presenter: presenter, historyViewController: historyVC)
            presenter.view = vc
            return vc
        }
    }
}
