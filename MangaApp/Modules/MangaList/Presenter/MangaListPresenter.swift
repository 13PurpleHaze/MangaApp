//
//  MangaListPresenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

import Foundation

// TODO: Убрать отсюда
enum ViewState {
    case isFetching, isSuccess, isError, isEndReached
}

protocol MangaListPresenterOutput: AnyObject {
    func didTapFilter(onApply: @escaping () -> Void)
    func openDetail(manga: Manga)
}

class MangaListPresenter: MangaListViewOutput {
    var mangas: [Manga] = []
    var filter = Filter()
    var state = ViewState.isFetching {
        didSet {
            view?.updateUI(state: state)
        }
    }

    private let mangaService: MangaServiceProtocol
    private let filterService: FilterServiceProtocol
    private let historyService: HistoryServiceProtocol

    weak var view: MangaListViewInput?
    weak var delegate: MangaListPresenterOutput?

    init(mangaService: MangaServiceProtocol, filterService: FilterServiceProtocol, historyService: HistoryServiceProtocol) {
        self.mangaService = mangaService
        self.filterService = filterService
        self.historyService = historyService
    }

    func openFilter(onApply: @escaping () -> Void) {
        delegate?.didTapFilter(onApply: onApply)
    }

    func openDetail(index: Int) {
        delegate?.openDetail(manga: mangas[index])
    }

    func fetchFilterFields() {
        filter = filterService.fetchFields()
        view?.setFilter(filter: filterService.fetchFields())
    }

    func saveFilter() {
        filterService.saveFields(filter: filter)
        if let search = filter.search {
            historyService.addRequest(text: search)
        }
    }

    func fetchMangas() {
        state = .isFetching

        mangaService.fetchMangas(filter: filter) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(mangas):
                    if self.filter.offset == 0 {
                        self.mangas.removeAll()
                    }
                    let existingIDs = Set(self.mangas.map { $0.id })
                    let uniqueNewMangas = mangas.filter { !existingIDs.contains($0.id) }

                    self.mangas.append(contentsOf: uniqueNewMangas)
                    self.state = mangas.count < self.filter.limit ? .isEndReached : .isSuccess
                case let .failure(err):
                    self.state = .isError
                }
            }
        }
    }

    func goToMangasSearch() {}
}
