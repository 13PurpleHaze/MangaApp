//
//  NetworkError.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

enum NetworkError: String, Error {
    case internalServerError = "Internal Server Error"
    case internetConnectionFailed = "Internet Connection Failed"
    case networkError = "Network Error"
}
