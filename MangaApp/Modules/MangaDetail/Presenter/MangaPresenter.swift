//
//  MangaDetailPresenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 13.08.2025.
//

class MangaDetailPresenter: MangaDetailViewOutput {
    weak var view: MangaDetailViewInput?
    weak var delegate: MangaDetailPresenterOutput?
    private let mangaService: MangaServiceProtocol
    
    init(mangaService: MangaServiceProtocol) {
        self.mangaService = mangaService
    }
    
    func goBack() {
        delegate?.goBack()
    }
    
    func openChaptersList(mangaID: String) {
        delegate?.openChapterList(mangaID: mangaID)
    }
}
