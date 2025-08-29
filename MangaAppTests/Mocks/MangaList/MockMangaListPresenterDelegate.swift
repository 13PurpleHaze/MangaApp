//
//  MockMangaListPresenterDelegate.swift
//  MangaApp
//
//  Created by Никита Новицкий on 29.08.2025.
//

@testable import MangaApp

class MockMangaListPresenterDelegate: MangaListPresenterOutput {
    var didTapFilterCalled = false
    var openDetailCalled = false

    func didTapFilter(onApply _: @escaping () -> Void) {
        didTapFilterCalled = true
    }

    func openDetail(manga _: Manga) {
        openDetailCalled = true
    }
}
