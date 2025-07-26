//
//  MangaDetailViewOutput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 13.08.2025.
//

protocol MangaDetailViewOutput: AnyObject {
    var view: MangaDetailViewInput? { get set }
    var delegate: MangaDetailPresenterOutput? { get set }
    
    func goBack()
    func openChaptersList(mangaID: String)
}

protocol MangaDetailPresenterOutput: AnyObject {
    func goBack()
    func openChapterList(mangaID: String)
}
