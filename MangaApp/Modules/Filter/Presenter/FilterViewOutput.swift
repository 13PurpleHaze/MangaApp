//
//  FilterViewOutput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 04.08.2025.
//

protocol FilterViewOutput: AnyObject {
    var delegate: FilterPresenterOutput? { get set }
    var view: FilterViewInput? { get set }
    var filterValues: FilterValues { get set }
    var filter: Filter { get set }
    
    func loadFilter()
    func clearFilter()
    func saveFilter()
    func closeFilter()
}
