//
//  ChaptersViewOutput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

import Foundation

protocol ChaptersViewOutput: AnyObject {
    var view: ChaptersViewInput? { get set }
    var delegate: ChaptersPresenterOutput? { get set }
    var chapterService: ChapterServiceProtocol { get }
    var state: ViewState { get }

    var chaptersByVolume: [String: [Chapter]] { get }
    var chapters: [Chapter] { get }

    func fetchChapters(mangaID: String, translated: Bool, limit: Int, offset: Int)
    func openChapter(chapterID: String, chapterNumber: Int)
}
