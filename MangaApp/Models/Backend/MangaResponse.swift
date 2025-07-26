//
//  MangaResponse.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

struct MangaCollectionResponse<T: Decodable>: Decodable {
    let data: [T]
}

struct MangaEntityResponse<T: Decodable>: Decodable {
    let data: T
}
