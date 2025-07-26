//
//  ChaptersAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

import UIKit
import Swinject

class ChaptersAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ChaptersViewController.self) { r in
            let presenter = ChaptersPresenter(chapterService: r.resolve(ChapterServiceProtocol.self)!)
            let vc = ChaptersViewController(presenter: presenter)
            presenter.view = vc
            return vc
        }
    }
    
    
}
