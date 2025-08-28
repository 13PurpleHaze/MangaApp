//
//  MangaService.swift
//  MangaApp
//
//  Created by Никита Новицкий on 31.07.2025.
//

import UIKit

protocol MangaServiceProtocol {
    func fetchPopularMangas(completion: @escaping (Result<[Manga], Error>) -> Void)
    func fetchNewMangas(completion: @escaping (Result<[Manga], Error>) -> Void)
    func fetchHighestRatedMangas(completion: @escaping (Result<[Manga], Error>) -> Void)
    func fetchMangas(filter: Filter, completion: @escaping (Result<[Manga], Error>) -> Void)
}

class MangaService: MangaServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchPopularMangas(completion: @escaping (Result<[Manga], Error>) -> Void) {
        var filter = Filter()
        filter.order = MangaOrder.views
        fetchMangas(filter: filter, completion: completion)
    }

    func fetchNewMangas(completion: @escaping (Result<[Manga], Error>) -> Void) {
        var filter = Filter()
        filter.order = MangaOrder.date
        fetchMangas(filter: filter, completion: completion)
    }

    func fetchHighestRatedMangas(completion: @escaping (Result<[Manga], Error>) -> Void) {
        var filter = Filter()
        filter.order = MangaOrder.rating
        fetchMangas(filter: filter, completion: completion)
    }

    func fetchMangas(filter: Filter, completion: @escaping (Result<[Manga], Error>) -> Void) {
        guard let request = RequestBuilder().setPath("/manga").setFilter(filter).build() else { return }
        print(request)
        networkManager.fetch(request: request) { (result: Result<MangaCollectionResponse<BackendManga>, Error>) in
            switch result {
            case let .success(responce):
                var resMangas: [Manga] = []
                let group = DispatchGroup()
                for manga in responce.data {
                    let title = manga.attributes.altTitles.first(where: { !$0.language.isEmpty })?.language ?? manga.attributes.title.language

                    guard let coverId = manga.relationships.first(where: { $0.type == "cover_art" })?.id else {
                        resMangas.append(Manga(id: manga.id, title: title, description: manga.attributes.description?.language, coverImageURL: nil))
                        continue
                    }

                    group.enter()
                    self.fetchMangaCoverImage(coverId: coverId) { result in
                        switch result {
                        case let .success(fileName):
                            resMangas.append(
                                Manga(
                                    id: manga.id,
                                    title: title,
                                    description: manga.attributes.description?.language,
                                    coverImageURL: "https://uploads.mangadex.org/covers/\(manga.id)/\(fileName)",
                                    characteristics: self.makeCharacteristics(manga: manga)
                                )
                            )
                        case let .failure(error):
                            completion(.failure(error))
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(resMangas))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func fetchMangaCoverImage(coverId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let coverRequest = RequestBuilder().setPath("/cover/\(coverId)").build() else { return }
        networkManager.fetch(request: coverRequest) { (result: Result<MangaEntityResponse<Image>, Error>) in
            switch result {
            case let .success(response):
                completion(.success(response.data.attributes.fileName))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    // TODO: Убрать локализацию на уровень view
    private func makeCharacteristics(manga: BackendManga) -> [String: String] {
        var characteristics = [String: String]()
        if let contentRating = manga.attributes.contentRating {
            characteristics["Content rating".localizable()] = contentRating.capitalized.localizable()
        }
        if let status = manga.attributes.status {
            characteristics["Status".localizable()] = status.capitalized.localizable()
        }
        if let year = manga.attributes.year {
            characteristics["Year".localizable()] = String(year)
        }
        if let lastChapter = manga.attributes.lastChapter {
            if !lastChapter.isEmpty {
                characteristics["Last chapter".localizable()] = lastChapter
            }
        }
        return characteristics
    }
}
