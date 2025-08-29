//
//  HistoryService.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Foundation

protocol HistoryServiceProtocol {
    func addRequest(text: String)
    func removeRequest(text: String)
    func fetchRequests(completion: @escaping ([String]) -> Void)
}

class HistoryService: HistoryServiceProtocol {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func addRequest(text: String) {
        var history = userDefaults.object(forKey: "history") as? [String] ?? []
        history.append(text)
        userDefaults.set(history, forKey: "history")
    }

    func removeRequest(text: String) {
        let history = userDefaults.object(forKey: "history") as? [String] ?? []
        userDefaults.set(history.filter { $0 != text }, forKey: "history")
    }

    func fetchRequests(completion: @escaping ([String]) -> Void) {
        let history = userDefaults.object(forKey: "history") as? [String] ?? []
        completion(history.reversed())
    }
}
