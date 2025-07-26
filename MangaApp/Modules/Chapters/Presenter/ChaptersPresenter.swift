//
//  ChaptersPresenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

import Foundation

protocol ChaptersPresenterOutput: AnyObject {
    func openChapter(chapterID: String, chapterNumber: Int)
}

class ChaptersPresenter: ChaptersViewOutput {
    weak var view: ChaptersViewInput?
    weak var delegate: ChaptersPresenterOutput?
    var chapterService: ChapterServiceProtocol
    var state: ViewState = .isFetching {
        didSet {
            view?.updateUI(state: state)
        }
    }
    
    var chaptersByVolume: [String: [Chapter]] = [:]
    var chapters: [Chapter] = []

    init(chapterService: ChapterServiceProtocol) {
        self.chapterService = chapterService
    }
    
    func fetchChapters(mangaID: String, translated: Bool, limit: Int, offset: Int) {
        state = .isFetching
        let language = translated ? Locale.current.language.languageCode?.identifier ?? "en" : "en"
        chapterService.fetchChapters(mangaID: mangaID, limit: limit, offset: offset, language: language) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chapters):
                    if offset == 0 {
                        self.chapters.removeAll()
                        self.chaptersByVolume.removeAll()
                    }
                    chapters.forEach { chapter in
                        let volumeKey = chapter.attributes.volume ?? "0"
                        print(volumeKey)
                        if self.chaptersByVolume[volumeKey] == nil {
                            self.chaptersByVolume[volumeKey] = []
                        }
                        self.chaptersByVolume[volumeKey]?.append(chapter)
                    }
                    
                    self.chapters.append(contentsOf: chapters)
                    print(self.chaptersByVolume)
                    self.state = chapters.count < limit ? .isEndReached : .isSuccess
                case .failure(let error):
                    self.state = .isError
                }
            }
        }
    }
    
    func openChapter(chapterID: String, chapterNumber: Int) {
        delegate?.openChapter(chapterID: chapterID, chapterNumber: chapterNumber)
    }
}
