//
//  Filter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 31.07.2025.
//

import UIKit

struct Filter {
    var search: String?
    var order: MangaOrder?
    var contentRating: [MangaContentRating] = []
    var status: [MangaStatus] = []
    var offset: Int = 0
    var limit: Int = 10
}

struct FilterValues {
    var order: [MangaOrder] = [.date, .rating, .views]
    var contentRating: [MangaContentRating] = [.safe, .suggestive, .erotica]
    var status: [MangaStatus] = [.ongoing, .completed, .hiatus, .cancelled]
    
    var fieldsCount = 3
}

protocol LocalizedFilterField: RawRepresentable, CaseIterable where RawValue == String {
    var localized: String { get }
    init?(localizedString: String)
}

extension LocalizedFilterField {
    var localized: String {
        return rawValue.localizable()
    }
    
    init?(localizedString: String) {
        guard let foundCase = Self.allCases.first(where: {
           $0.localized == localizedString
       }) else {
           return nil
       }
       self = foundCase
   }
}

enum MangaOrder: String, CaseIterable, LocalizedFilterField {
    case date = "By date"
    case rating = "By rating"
    case views = "By views"
}

enum MangaContentRating: String, CaseIterable, LocalizedFilterField {
    case safe = "Safe"
    case suggestive = "Suggestive"
    case erotica = "Erotica"
    case porn = "Pornographic"
}

enum MangaStatus: String, CaseIterable, LocalizedFilterField {
    case ongoing = "Ongoing"
    case completed = "Completed"
    case hiatus = "Hiatus"
    case cancelled = "Cancelled"
}
