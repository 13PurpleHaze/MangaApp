//
//  MockMangaListView.swift
//  MangaApp
//
//  Created by Никита Новицкий on 29.08.2025.
//

@testable import MangaApp

class MockMangaListView: MangaListViewInput {
    var presenter: MangaListViewOutput
    var setFilterCalled = false
    var statePassed: ViewState?

    init(presenter: MangaListViewOutput) {
        self.presenter = presenter
    }

    func updateUI(state: ViewState) {
        statePassed = state
    }

    func setFilter(filter _: Filter) {
        setFilterCalled = true
    }
}
