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
    func addRequest(text: String) {
        var history = UserDefaults.standard.object(forKey: "history") as? Array<String> ?? []
        history.append(text)
        UserDefaults.standard.set(history, forKey: "history")
    }
    
    func removeRequest(text: String) {
        let history = UserDefaults.standard.object(forKey: "history") as? Array<String> ?? []
        UserDefaults.standard.set(history.filter { $0 != text }, forKey: "history")
    }
    
    func fetchRequests(completion: @escaping ([String]) -> Void) {
        let history = UserDefaults.standard.object(forKey: "history") as? Array<String> ?? []
        completion(history.reversed())
    }
}
