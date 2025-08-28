//
//  HistoryServiceTest.swift
//  MangaAppTests
//
//  Created by Никита Новицкий on 28.08.2025.
//

@testable import MangaApp
import XCTest

final class HistoryServiceTest: XCTestCase {
    var sut: HistoryService!
    var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        sut = HistoryService(userDefaults: mockUserDefaults)
    }

    override func tearDown() {
        sut = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    func testAddRequest_whenAdded_souldBeStored() {
        let dummyText = "Dummy"
        sut.addRequest(text: dummyText)
        let history = mockUserDefaults.storage["history"] as? [String]
        XCTAssertEqual(dummyText, history?.first)
    }

    func testRemoveRequest_whenRemoved_shouldNotBeStored() {
        mockUserDefaults.storage["history"] = ["Dummy"]
        sut.removeRequest(text: "Dummy")
        let history = mockUserDefaults.storage["history"] as? [String]
        XCTAssertEqual(history, [])
    }

    func testRemoveRequest_whenItemNotExists_shouldNotChangeHistory() {
        mockUserDefaults.storage["history"] = ["Dummy"]
        sut.removeRequest(text: "Another dummy")
        let history = mockUserDefaults.storage["history"] as? [String]
        XCTAssertEqual(history, ["Dummy"])
    }

    func testFetchRequest_whenCalled_shouldReturnStoredRequests() {
        let dummyTexts = ["Dummy1", "Dummy2"]
        mockUserDefaults.storage["history"] = dummyTexts
        let expectation = expectation(description: "Expectation")
        sut.fetchRequests { result in
            XCTAssertEqual(result, dummyTexts.reversed())
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
