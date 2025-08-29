//
//  FilterServiceTest.swift
//  MangaAppTests
//
//  Created by Никита Новицкий on 28.08.2025.
//

@testable import MangaApp
import XCTest

final class FilterServiceTest: XCTestCase {
    var sut: FilterService!
    var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        sut = FilterService(userDefaults: mockUserDefaults)
    }

    override func tearDown() {
        mockUserDefaults = nil
        sut = nil
        super.tearDown()
    }

    func testSaveFields_whenSave_shouldBeStored() {
        let filter = Filter(
            search: "Spy x family",
            order: .date,
            contentRating: [.safe, .suggestive],
            status: [.ongoing, .completed]
        )

        sut.saveFields(filter: filter)

        XCTAssertEqual(filter.search!, mockUserDefaults.storage["filter.search"] as? String)
        XCTAssertEqual(MangaOrder.date.rawValue, mockUserDefaults.storage["filter.order"] as? String)
        XCTAssertEqual([
            MangaContentRating.safe.rawValue,
            MangaContentRating.suggestive.rawValue,
        ], mockUserDefaults.storage["filter.contentRating"] as? [String])
        XCTAssertEqual([
            MangaStatus.ongoing.rawValue,
            MangaStatus.completed.rawValue,
        ], mockUserDefaults.storage["filter.status"] as? [String])
    }

    func testsSaveFilter_whenSaveEmptyFilter_shouldBeStoredEmptyValues() {
        sut.saveFields(filter: Filter())
        let savedContentRating = mockUserDefaults.storage["filter.contentRating"] as? [String]
        let savedStatus = mockUserDefaults.storage["filter.status"] as? [String]
        let savedOrder = mockUserDefaults.storage["filter.order"] as? String
        let savedSearch = mockUserDefaults.storage["filter.search"] as? String

        XCTAssertEqual(savedContentRating, [])
        XCTAssertEqual(savedStatus, [])
        XCTAssertNil(savedOrder)
        XCTAssertNil(savedSearch)
    }

    func testFetchFields_shouldReturnSavedFilter() {
        mockUserDefaults.storage["filter.contentRating"] = [MangaContentRating.safe.rawValue, MangaContentRating.suggestive.rawValue]
        let filter = sut.fetchFields()
        XCTAssertEqual(filter.contentRating, [MangaContentRating.safe, MangaContentRating.suggestive])
    }

    func testFetchFields_whenEmptyValues_shouldReturnEmptyFilter() {
        let filter = sut.fetchFields()
        XCTAssertEqual(filter.contentRating, [])
        XCTAssertEqual(filter.status, [])
        XCTAssertNil(filter.order)
        XCTAssertNil(filter.search)
    }
}
