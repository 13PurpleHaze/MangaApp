//
//  MangaAttributes.swift
//  MangaApp
//
//  Created by Никита Новицкий on 31.07.2025.
//

struct MangaAttributes: Decodable {
    var title: LocalizedText
    var altTitles: [LocalizedText]
    var description: LocalizedText?
    var year: Int?
    var contentRating: String?
    var status: String?
    var lastChapter: String?
}
