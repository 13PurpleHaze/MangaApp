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
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //print("Error")
            if error != nil {
                completion(.failure(NetworkError.NetworkError))
                return
            }
            //print("No Error")
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.NetworkError))
                return
            }
            //print("Good res")
            switch response.statusCode {
            case 200..<300:
                //print("Data")
                guard let data = data else {
                    completion(.failure(NetworkError.NetworkError))
                    return
                }
                //print("Good data")
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                    return
                } catch {
                    completion(.failure(NetworkError.NetworkError))
                    return
                }
            default:
                completion(.failure(NetworkError.InternalServerError))
                return
            }
        }
        task.resume()
    }
}
