//
//  HomePesenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//
import UIKit

protocol HomePresenterOutput: AnyObject {
    func openDetail(manga: Manga)
}

class HomePresenter: HomeViewOutput {    
    weak var view: HomeViewInput?
    private var state: ViewState = .isFetching {
        didSet {
            view?.updateUI(state: state)
        }
    }
    private let mangaService: MangaServiceProtocol
    weak var delegate: HomePresenterOutput?
    
    var popularManga: [Manga] = []
    var newManga: [Manga] = []
    var highestRatedManga: [Manga] = []
    
    init(mangaService: MangaServiceProtocol) {
        self.mangaService = mangaService
    }
    
    func openDetail(manga: Manga) {
        delegate?.openDetail(manga: manga)
    }
    
    func fetchManga() {
//        self.view?.setMangas(newMangas: self.newManga, popularMangas: self.popularManga, hightRatedMangas: self.highestRatedManga)
        //return
        state = .isFetching
        let group = DispatchGroup()
        group.enter()
        mangaService.fetchHighestRatedMangas { result in
            switch result {
            case .success(let mangas):
                self.highestRatedManga = mangas
            case .failure(let error):
                self.state = .isError
            }
            group.leave()
        }
        group.enter()
        mangaService.fetchNewMangas { result in
            switch result {
            case .success(let mangas):
                self.newManga = mangas
            case .failure(let error):
                self.state = .isError
            }
            group.leave()
        }
        group.enter()
        mangaService.fetchPopularMangas { result in
            switch result {
            case .success(let mangas):
                self.popularManga = mangas
            case .failure(let error):
                self.state = .isError
            }
            group.leave()
        }
        group.notify(queue: .main) {
            self.state = .isSuccess
        }
    }
}
