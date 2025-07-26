//
//  ChapterDetailCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

class ChapterDetailCoordinator: BaseCoordinator {
    func start(chapterID: String, chapterNumber: Int) {
        let vc = resolver.resolve(ChapterDetailViewController.self)!
        vc.chapterID = chapterID
        vc.chapterNumber = chapterNumber
        vc.presenter.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension ChapterDetailCoordinator: ChapterDetailPresenterOutput {
    func goBack() {
        navigationController.popViewController(animated: false)
    }
}
