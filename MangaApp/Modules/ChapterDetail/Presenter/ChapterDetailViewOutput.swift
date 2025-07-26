//
//  ChapterDetailViewOutput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

protocol ChapterDetailViewOutput: AnyObject {
    var view: ChapterDetailViewInput? { get set }
    var delegate: ChapterDetailPresenterOutput? { get set }
    var chapterService: ChapterServiceProtocol { get }
    var chapters: [String] { get }
    
    func fetchChapter(chapterID: String)
    func goBack()
}
