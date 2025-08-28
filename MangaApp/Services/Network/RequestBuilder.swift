//
//  RequestBuilder.swift
//  MangaApp
//
//  Created by Никита Новицкий on 31.07.2025.
//

import Foundation

class RequestBuilder {
    private let baseUrl = "api.mangadex.org"
    private var urlComponents = URLComponents()
    private var path = ""
    private var method: HTTPMethod = .get
    private var headers: [String: String] = [:]
    private var data: Data?
    private var queryItems: [URLQueryItem] = []

    init() {
        headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
    }

    func setPath(_ path: String) -> Self {
        self.path = path
        return self
    }

    func setMethod(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    func setHeaders(_ newHeaders: [String: String]) -> Self {
        for (key, value) in newHeaders {
            headers[key] = value
        }
        return self
    }

    func setBody(_ data: Data?) -> Self {
        self.data = data
        return self
    }

    func setQueryItems(_ queryItems: [URLQueryItem]) -> Self {
        self.queryItems.append(contentsOf: queryItems)
        return self
    }

    func setLimitOffset(limit: Int, offset: Int) -> Self {
        var items: [URLQueryItem] = []
        items.append(URLQueryItem(name: "offset", value: "\(offset)"))
        items.append(URLQueryItem(name: "limit", value: "\(limit)"))
        return setQueryItems(items)
    }

    // TODO: убрать отсюда упоминание фильтра и перенсти это в фичу фильтра
    func setFilter(_ filter: Filter) -> Self {
        var items: [URLQueryItem] = []
        if let search = filter.search {
            if !search.isEmpty {
                items.append(URLQueryItem(name: "title", value: search))
            }
        }
        if let order = filter.order {
            switch order {
            case MangaOrder.date:
                items.append(URLQueryItem(name: "order[createdAt]", value: "desc"))
            case MangaOrder.rating:
                items.append(URLQueryItem(name: "order[rating]", value: "desc"))
            case MangaOrder.views:
                items.append(URLQueryItem(name: "order[relevance]", value: "desc"))
            }
        }
        if !filter.contentRating.isEmpty {
            for r in filter.contentRating {
                items.append(URLQueryItem(name: "contentRating[]", value: "\(r.rawValue.lowercased())"))
            }
        }
        if !filter.status.isEmpty {
            for r in filter.status {
                items.append(URLQueryItem(name: "status[]", value: "\(r.rawValue.lowercased())"))
            }
        }
        items.append(URLQueryItem(name: "offset", value: "\(filter.offset)"))
        items.append(URLQueryItem(name: "limit", value: "\(filter.limit)"))
        return setQueryItems(items)
    }

    func build() -> URLRequest? {
        urlComponents.host = baseUrl
        urlComponents.path = path
        urlComponents.port = 443
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        urlComponents.scheme = "https"

        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        request.allHTTPHeaderFields = headers
        return request
    }
}
