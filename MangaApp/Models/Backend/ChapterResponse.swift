//
//  ChapterResponse.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

struct ChapterResponse: Decodable {
    var baseUrl: String
    var chapter: BackendChapter
}

struct BackendChapter: Decodable {
    var hash: String
    var data: [String]
}
