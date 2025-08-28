//
//  ChapterAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

import Swinject
import UIKit

class ChapterAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ChapterDetailViewController.self) { r in
            let presenter = ChapterDetailPresenter(chapterService: r.resolve(ChapterServiceProtocol.self)!)
            let vc = ChapterDetailViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }
    }
}
