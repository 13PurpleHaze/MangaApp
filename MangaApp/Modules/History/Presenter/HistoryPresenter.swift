//
//  HistoryPresenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

protocol HistoryPresenterOutput: AnyObject {
    func didSelect(text: String)
}

class HistoryPresenter: HistoryViewOutput {
    weak var view: HistoryViewInput?
    weak var delegate: HistoryPresenterOutput?
    
    private let historyService: HistoryServiceProtocol
    var history: [String] = []
    var state: ViewState = .isFetching {
        didSet {
            view?.updateUI(state: state)
        }
    }
    
    init(historyService: HistoryServiceProtocol) {
        self.historyService = historyService
    }
    
    func didSelect(text: String) {
        print(delegate)
        delegate?.didSelect(text: text)
    }
    
    func fetchHistory() {
        state = .isFetching
        historyService.fetchRequests { history in
            self.history = history
            self.state = .isSuccess
        }
    }
    
    func removeHistoryRequest(text: String) {
        historyService.removeRequest(text: text)
        history.removeAll { $0 == text }
    }
}
