//
//  HistoryViewInput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

protocol HistoryViewInput: AnyObject {
    var presenter: HistoryViewOutput { get }
    func updateUI(state: ViewState)
}
