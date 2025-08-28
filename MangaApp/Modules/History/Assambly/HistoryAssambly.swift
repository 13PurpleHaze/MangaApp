//
//  HistoryAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Swinject
import UIKit

class HistoryAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(HistoryViewController.self) { r in
            let presenter = HistoryPresenter(historyService: r.resolve(HistoryServiceProtocol.self)!)
            let vc = HistoryViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }
    }
}
