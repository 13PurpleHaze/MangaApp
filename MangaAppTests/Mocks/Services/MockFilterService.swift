//
//  MockFilterService.swift
//  MangaApp
//
//  Created by Никита Новицкий on 29.08.2025.
//

@testable import MangaApp

class MockFilterService: FilterServiceProtocol {
    var saveFieldsCalled = false
    var fetchFieldsCalled = false
    var filterToReturn = Filter()

    func saveFields(filter _: Filter) {
        saveFieldsCalled = true
    }

    func fetchFields() -> Filter {
        fetchFieldsCalled = true
        return filterToReturn
    }
}
