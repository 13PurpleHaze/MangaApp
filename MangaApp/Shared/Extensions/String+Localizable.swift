//
//  String+Localizable.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

import Foundation

extension String {
    func localizable() -> String {
        NSLocalizedString(self, comment: "")
    }

    func localizable(_ arguments: CVarArg...) -> String {
        String(format: String(localized: String.LocalizationValue(self)), arguments: arguments)
    }
}
