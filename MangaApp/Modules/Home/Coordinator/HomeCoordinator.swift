//
//  HomeCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 09.08.2025.
//

class HomeCoordinator: BaseCoordinator {
    override func start() {
        let vc = resolver.resolve(HomeViewController.self)!
        vc.presenter.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension HomeCoordinator: HomePresenterOutput {
    func openDetail(manga: Manga) {
        let mangaDetailCoordinator = MangaDetailCoordinator(navigationController: navigationController, resolver: resolver)
        addChildCoordinator(mangaDetailCoordinator)
        mangaDetailCoordinator.start(manga: manga)
    }
}
