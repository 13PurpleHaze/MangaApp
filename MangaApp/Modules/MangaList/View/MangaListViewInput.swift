//
//  MangaListViewInput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

protocol MangaListViewInput: AnyObject {
    var presenter: MangaListViewOutput { get }
    
    func setFilter(filter: Filter)
    func updateUI(state: ViewState)
}
