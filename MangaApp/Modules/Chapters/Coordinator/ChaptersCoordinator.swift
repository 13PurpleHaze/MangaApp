//
//  ChaptersCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

class ChaptersCoordinator: BaseCoordinator {
    func start(mangaID: String) {
        let vc = resolver.resolve(ChaptersViewController.self)!
        vc.mangaID = mangaID
        vc.presenter.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension ChaptersCoordinator: ChaptersPresenterOutput {
    func openChapter(chapterID: String, chapterNumber: Int) {
        let coordinator = ChapterDetailCoordinator(navigationController: navigationController, resolver: resolver)
        addChildCoordinator(coordinator)
        coordinator.start(chapterID: chapterID, chapterNumber: chapterNumber)
    }
}
