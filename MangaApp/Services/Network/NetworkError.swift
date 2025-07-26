//
//  NetworkError.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

enum NetworkError: String, Error {
    case InternalServerError = "Internal Server Error"
    case InternetConnectionFailed = "Internet Connection Failed"
    case NetworkError = "Network Error"
}
