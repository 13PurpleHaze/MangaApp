//
//  MangaListViewOutput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

protocol MangaListViewOutput: AnyObject {
    var delegate: MangaListPresenterOutput? { get set }
    var view: MangaListViewInput? { get set }
    
    var mangas: [Manga] { get }
    var filter: Filter { get set }
    var state: ViewState { get }
    
    func fetchMangas()
    func openFilter(onApply: @escaping () -> Void)
    func fetchFilterFields()
    func saveFilter()
    func openDetail(index: Int)
}
