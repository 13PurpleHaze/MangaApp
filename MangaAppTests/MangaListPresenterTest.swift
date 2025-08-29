//
//  MangaListPresenterTest.swift
//  MangaAppTests
//
//  Created by Никита Новицкий on 29.08.2025.
//

@testable import MangaApp
import XCTest

final class MangaListPresenterTest: XCTestCase {
    var sut: MangaListPresenter!
    var mockMangaService: MockMangaService!
    var mockFilterService: MockFilterService!
    var mockHistoryService: MockHistoryService!
    var mockView: MockMangaListView!
    var mockPresenterDelegate: MockMangaListPresenterDelegate!
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        mockMangaService = MockMangaService()
        mockFilterService = MockFilterService()
        mockHistoryService = MockHistoryService()
        mockPresenterDelegate = MockMangaListPresenterDelegate()

        sut = MangaListPresenter(
            mangaService: mockMangaService,
            filterService: mockFilterService,
            historyService: mockHistoryService
        )
        mockView = MockMangaListView(presenter: sut)
        sut.view = mockView
        sut.delegate = mockPresenterDelegate
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockMangaService = nil
        mockFilterService = nil
        mockHistoryService = nil
        mockPresenterDelegate = nil
        super.tearDown()
    }

    func testFetchMangas_whenSuccess_shouldUpdateMangasAndViewState() {
        mockMangaService.resultToReturn = Result<[Manga], Error>.success([
            Manga(id: "1", title: "Spy x family", description: "desc", coverImageURL: "..."),
        ])
        let expectation = self.expectation(description: "Expectation")

        sut.fetchMangas()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.mangas.count, 1)
            XCTAssertEqual(self.sut.mangas.first?.id, "1")
            XCTAssertEqual(self.mockView.statePassed, .isEndReached)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetchMangas_whenFailure_shouldNotUpdateMangasAndUpdateViewState() {
        mockMangaService.resultToReturn = Result<[Manga], Error>.failure(NetworkError.internalServerError)
        let expectation = self.expectation(description: "Expectation")

        sut.fetchMangas()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.mangas.count, 0)
            XCTAssertEqual(self.mockView.statePassed, .isError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetchMangas_whenMangasEqualsLimit_shouldUpdateMangasAndViewState() {
        mockMangaService.resultToReturn = Result<[Manga], Error>.success([
            Manga(id: "1", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "2", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "3", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "4", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "5", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "6", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "7", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "8", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "9", title: "Spy x family", description: "desc", coverImageURL: "..."),
            Manga(id: "10", title: "Spy x family", description: "desc", coverImageURL: "..."),
        ])
        let expectation = self.expectation(description: "Expectation")
        sut.fetchMangas()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.mangas.count, 10)
            XCTAssertEqual(self.sut.mangas.first?.id, "1")
            XCTAssertEqual(self.sut.mangas.last?.id, "10")
            XCTAssertEqual(self.mockView.statePassed, .isSuccess)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testOpenFilter_shouldCallDelegate() {
        sut.openFilter {}
        XCTAssertTrue(mockPresenterDelegate.didTapFilterCalled)
    }

    func testOpenDetail_dhouldCallDelegate() {
        sut.mangas = [Manga(id: "1", title: "Spy x family", description: "desc", coverImageURL: "...")]
        sut.openDetail(index: 0)
        XCTAssertTrue(mockPresenterDelegate.openDetailCalled)
    }

    func testFetchFilterFields_shouldCallFilterService() {
        sut.fetchFilterFields()
        XCTAssertTrue(mockFilterService.fetchFieldsCalled)
        XCTAssertTrue(mockView.setFilterCalled)
    }

    func testSaveFilter_shouldSaveFilterAndAddHistory() {
        sut.filter.search = "Search"
        sut.saveFilter()
        XCTAssertTrue(mockFilterService.saveFieldsCalled)
        XCTAssertTrue(mockHistoryService.addRequestCalled)
    }

    func testSaveFilter_whenNoSearch_shouldSaveFilterAndNotAddHistory() {
        sut.saveFilter()
        XCTAssertTrue(mockFilterService.saveFieldsCalled)
        XCTAssertFalse(mockHistoryService.addRequestCalled)
    }
}
