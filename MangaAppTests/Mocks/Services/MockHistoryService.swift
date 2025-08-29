//
//  MockHistoryService.swift
//  MangaApp
//
//  Created by Никита Новицкий on 29.08.2025.
//

@testable import MangaApp

class MockHistoryService: HistoryServiceProtocol {
    var addRequestCalled = false
    var removeRequestCalled = false
    var fetchRequestsCalled = false

    func addRequest(text _: String) {
        addRequestCalled = true
    }

    func removeRequest(text _: String) {
        removeRequestCalled = true
    }

    func fetchRequests(completion: @escaping ([String]) -> Void) {
        fetchRequestsCalled = true
        completion([])
    }
}
