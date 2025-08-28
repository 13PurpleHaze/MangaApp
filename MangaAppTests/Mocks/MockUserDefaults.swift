//
//  MockUserDefaults.swift
//  MangaApp
//
//  Created by Никита Новицкий on 28.08.2025.
//

import Foundation

class MockUserDefaults: UserDefaults {
    var storage: [String: Any] = [:]

    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

    override func object(forKey defaultName: String) -> Any? {
        storage[defaultName]
    }
}
