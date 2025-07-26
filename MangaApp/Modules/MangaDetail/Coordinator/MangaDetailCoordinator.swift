//
//  MangaDetailCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 13.08.2025.
//

class MangaDetailCoordinator: BaseCoordinator {
    func start(manga: Manga) {
        let vc = resolver.resolve(MangaDetailViewController.self)!
        vc.manga = manga
        vc.presenter.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MangaDetailCoordinator: MangaDetailPresenterOutput {
    func openChapterList(mangaID: String) {
        let coordinator = ChaptersCoordinator(navigationController: navigationController, resolver: resolver)
        addChildCoordinator(coordinator)
        coordinator.start(mangaID: mangaID)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
