//
//  ChapterService.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

import Foundation

protocol ChapterServiceProtocol {
    func fetchChapters(mangaID: String, limit: Int, offset: Int, language: String?, completion: @escaping (Result<[Chapter], Error>) -> Void)
    func fetchChapterByID(chapterID: String, completion: @escaping (Result<[String], Error>) -> Void)
}

class ChapterService: ChapterServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchChapters(mangaID: String, limit: Int, offset: Int, language: String? = nil, completion: @escaping (Result<[Chapter], Error>) -> Void) {
        var items: [URLQueryItem] = []
        if let language = language {
            items.append(URLQueryItem(name: "translatedLanguage[]", value: language))
        }
        items.append(contentsOf: [
            URLQueryItem(name: "order[volume]", value: "desc"),
            URLQueryItem(name: "order[chapter]", value: "desc")
        ])
    
        guard let request = RequestBuilder()
            .setPath("/manga/\(mangaID)/feed")
            .setQueryItems(items)
            .setLimitOffset(limit: limit, offset: offset)
            .build() else { return }
        
        print(request)
        networkManager.fetch(request: request) { (result: Result<MangaCollectionResponse<Chapter>, Error>) in
            switch(result) {
            case .success(let responce):
                completion(.success(responce.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchChapterByID(chapterID: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let request = RequestBuilder().setPath("/at-home/server/\(chapterID)").build() else {
            return
        }
        
        networkManager.fetch(request: request) { (result: Result<ChapterResponse, Error>) in
            switch(result) {
            case .success(let responce):
                let data = responce.chapter.data.map { "https://uploads.mangadex.org/data/\(responce.chapter.hash)/\($0)" }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
