//
//  ChapterDetailPresenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

import Foundation

protocol ChapterDetailPresenterOutput: AnyObject {
    func goBack()
}

class ChapterDetailPresenter: ChapterDetailViewOutput {
    weak var view: ChapterDetailViewInput?
    weak var delegate: ChapterDetailPresenterOutput?
    var chapterService: ChapterServiceProtocol
    var chapters: [String] = []
    var state: ViewState = .isFetching {
        didSet {
            view?.updateUI(state: state)
        }
    }

    init(chapterService: any ChapterServiceProtocol) {
        self.chapterService = chapterService
    }

    func fetchChapter(chapterID: String) {
        state = .isFetching
        chapterService.fetchChapterByID(chapterID: chapterID) { response in
            DispatchQueue.main.async {
                switch response {
                case let .success(chapters):
                    self.chapters = chapters
                    self.state = .isSuccess
                case let .failure(error):
                    self.state = .isError
                }
            }
        }
    }

    func goBack() {
        delegate?.goBack()
    }
}
