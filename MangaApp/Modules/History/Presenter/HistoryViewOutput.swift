//
//  HistoryViewOutput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

protocol HistoryViewOutput: AnyObject {
    var view: HistoryViewInput? { get set }
    var delegate: HistoryPresenterOutput? { get set }

    var history: [String] { get }
    var state: ViewState { get }

    func didSelect(text: String)
    func fetchHistory()
    func removeHistoryRequest(text: String)
}
