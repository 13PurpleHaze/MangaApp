//
//  MockNetworkManager.swift
//  MangaApp
//
//  Created by Никита Новицкий on 28.08.2025.
//

import Foundation
@testable import MangaApp

class MockNetworkManager: NetworkManagerProtocol {
    var request: URLRequest?
    var resultsToReturn: [Any] = []

    func fetch<T>(request: URLRequest, completion: @escaping (Result<T, any Error>) -> Void) where T: Decodable {
        self.request = request

        guard !resultsToReturn.isEmpty else {
            completion(.failure(NetworkError.networkError))
            return
        }

        if let result = resultsToReturn.removeFirst() as? Result<T, Error> {
            completion(result)
        } else {
            completion(.failure(NetworkError.networkError))
        }
    }
}
