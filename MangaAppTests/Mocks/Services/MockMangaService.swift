//
//  MockMangaService.swift
//  MangaApp
//
//  Created by Никита Новицкий on 29.08.2025.
//

@testable import MangaApp

class MockMangaService: MangaServiceProtocol {
    var fetchMangasCalled = false
    var filterPassed: Filter?
    var resultToReturn: Result<[Manga], Error>?

    func fetchPopularMangas(completion _: @escaping (Result<[Manga], Error>) -> Void) {}
    func fetchNewMangas(completion _: @escaping (Result<[Manga], Error>) -> Void) {}
    func fetchHighestRatedMangas(completion _: @escaping (Result<[Manga], Error>) -> Void) {}

    func fetchMangas(filter: Filter, completion: @escaping (Result<[Manga], Error>) -> Void) {
        fetchMangasCalled = true
        filterPassed = filter
        if let result = resultToReturn {
            completion(result)
        }
    }
}
