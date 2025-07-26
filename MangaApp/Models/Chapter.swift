//
//  Chapter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

struct Chapter: Decodable, Hashable {
    var id: String
    var attributes: ChapterAttributes
}

struct ChapterAttributes: Decodable, Hashable {
    var title: String?
    var chapter: String?
    var volume: String?
    var pages: Int?
    var version: Int?
    var translatedLanguage: String?
}
