//
//  MangaListCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 09.08.2025.
//

class MangaListCoordinator: BaseCoordinator {
    override func start() {
        let vc = resolver.resolve(MangaListViewController.self)!
        vc.presenter.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }

    func openFilter(onApply: @escaping () -> Void) {
        let filterCoordinator = FilterCoordinator(navigationController: navigationController, resolver: resolver)
        filterCoordinator.onApply = onApply
        addChildCoordinator(filterCoordinator)
        filterCoordinator.start()
    }
}

extension MangaListCoordinator: MangaListPresenterOutput {
    func openDetail(manga: Manga) {
        let mangaDetailCoordinator = MangaDetailCoordinator(navigationController: navigationController, resolver: resolver)
        addChildCoordinator(mangaDetailCoordinator)
        mangaDetailCoordinator.start(manga: manga)
    }

    func didTapFilter(onApply: @escaping () -> Void) {
        openFilter(onApply: onApply)
    }
}
