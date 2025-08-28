//
//  FilterService.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Foundation

protocol FilterServiceProtocol {
    func saveFields(filter: Filter)
    func fetchFields() -> Filter
}

class FilterService: FilterServiceProtocol {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func saveFields(filter: Filter) {
        userDefaults.set(filter.contentRating.map { $0.rawValue }, forKey: "filter.contentRating")
        userDefaults.set(filter.status.map { $0.rawValue }, forKey: "filter.status")
        userDefaults.set(filter.order?.rawValue, forKey: "filter.order")
        userDefaults.set(filter.search, forKey: "filter.search")
    }

    func fetchFields() -> Filter {
        var filter = Filter()
        if let contentRating = userDefaults.object(forKey: "filter.contentRating") as? [String] {
            filter.contentRating = contentRating.map { MangaContentRating(rawValue: $0) ?? .safe }
        }
        if let status = userDefaults.object(forKey: "filter.status") as? [String] {
            filter.status = status.map { MangaStatus(rawValue: $0) ?? .completed }
        }
        if let order = userDefaults.object(forKey: "filter.order") as? String {
            filter.order = MangaOrder(rawValue: order)
        }
        if let search = userDefaults.object(forKey: "filter.search") as? String {
            filter.search = search
        }
        return filter
    }
}
