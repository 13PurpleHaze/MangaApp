//
//  BackendManga.swift
//  MangaApp
//
//  Created by Никита Новицкий on 31.07.2025.
//

struct BackendManga: Decodable {
    var id: String
    var attributes: MangaAttributes
    var relationships: [Relationship]
}
