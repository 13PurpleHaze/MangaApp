//
//  Image.swift
//  MangaApp
//
//  Created by Никита Новицкий on 31.07.2025.
//

struct Image: Decodable {
    let id: String
    let attributes: Attributes
    
    struct Attributes: Decodable {
        let fileName: String
    }
}
