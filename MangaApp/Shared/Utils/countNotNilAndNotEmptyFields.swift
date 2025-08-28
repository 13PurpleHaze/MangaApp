//
//  countNotNilAndNotEmptyFields.swift
//  MangaApp
//
//  Created by Никита Новицкий on 25.08.2025.
//

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool {
        return self == nil
    }
}

func countNotNilAndNotEmptyFields<T>(of instance: T) -> Int {
    let mirror = Mirror(reflecting: instance)
    return mirror.children.reduce(0) { count, child in
        if let value = child.value as? [Any], !value.isEmpty {
            return count + 1
        }
        if let value = child.value as? AnyOptional, !value.isNil {
            return count + 1
        }
        return count
    }
}
