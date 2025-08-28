//
//  NetworkManager.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(NetworkError.networkError))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.networkError))
                return
            }
            switch response.statusCode {
            case 200 ..< 300:
                guard let data = data else {
                    completion(.failure(NetworkError.networkError))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                    return
                } catch {
                    completion(.failure(NetworkError.networkError))
                    return
                }
            default:
                completion(.failure(NetworkError.internalServerError))
                return
            }
        }
        task.resume()
    }
}
