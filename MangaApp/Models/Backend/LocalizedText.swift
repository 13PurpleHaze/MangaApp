//
//  LocalizedText.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

import Foundation

struct LocalizedText: Decodable {
    var en: String?
    var ja: String?
    var pl: String?
    var ru: String?
    
    var language: String {
        let language = Locale.current.language.languageCode?.identifier ?? "en"
        switch language {
        case "ru":
            return ru ?? en ?? ""
        case "ja":
            return ja ?? en ?? ""
        case "pl":
            return pl ?? en ?? ""
        default:
            return en ?? ""
        }
    }
}
