//
//  RootAssambly.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import Swinject

class RootAssambly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(NetworkManagerProtocol.self) { _ in NetworkManager() }
        container.register(MangaServiceProtocol.self) { r in
            MangaService(networkManager: r.resolve(NetworkManagerProtocol.self)!)
        }
        container.register(FilterServiceProtocol.self) { _ in
            FilterService()
        }
        container.register(ChapterServiceProtocol.self) { r in
            ChapterService(networkManager: r.resolve(NetworkManagerProtocol.self)!)
        }
        container.register(HistoryServiceProtocol.self) { _ in
            HistoryService()
        }
    }
}
