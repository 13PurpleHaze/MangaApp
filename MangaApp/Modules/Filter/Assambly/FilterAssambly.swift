//
//  FilterAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Swinject
import UIKit

class FilterAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(FilterViewController.self) { r in
            let presenter = FilterPresenter(filterService: r.resolve(FilterServiceProtocol.self)!)
            let vc = FilterViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }
    }
}
