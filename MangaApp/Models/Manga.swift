//
//  Manga.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

struct Manga: Decodable, Hashable {
    let id: String
    let title: String
    let description: String?
    let coverImageURL: String?
    var characteristics: [String: String]?
}
