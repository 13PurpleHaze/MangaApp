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
    func saveFields(filter: Filter) {
        UserDefaults.standard.set(filter.contentRating.map { $0.rawValue }, forKey: "filter.contentRating")
        UserDefaults.standard.set(filter.status.map { $0.rawValue }, forKey: "filter.status")
        UserDefaults.standard.set(filter.order?.rawValue, forKey: "filter.order")
        UserDefaults.standard.set(filter.search, forKey: "filter.search")
    }
    
    func fetchFields() -> Filter {
        var filter = Filter()
        if let contentRating = UserDefaults.standard.object(forKey: "filter.contentRating") as? NSArray {
            filter.contentRating = (contentRating.map { MangaContentRating(rawValue: $0 as! String)} as? Array)!
        }
        if let status = UserDefaults.standard.object(forKey: "filter.status") as? NSArray {
            filter.status = (status.map { MangaStatus(rawValue: $0 as! String)} as? Array)!
        }
        if let order = UserDefaults.standard.object(forKey: "filter.order") as? String {
            filter.order = MangaOrder(rawValue: order)
        }
        if let search = UserDefaults.standard.object(forKey: "filter.search") as? String {
            filter.search = search
        }
        return filter
    }
}
