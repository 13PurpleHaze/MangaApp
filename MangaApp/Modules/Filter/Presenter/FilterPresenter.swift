//
//  FilterPresenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 04.08.2025.
//

import Foundation

protocol FilterPresenterOutput: AnyObject {
    func closeFilter()
}

class FilterPresenter: FilterViewOutput {
    private let filterService: FilterServiceProtocol
    weak var view: FilterViewInput?
    weak var delegate: FilterPresenterOutput?
    var filterValues = FilterValues()
    var filter = Filter()
    
    init(filterService: FilterServiceProtocol) {
        self.filterService = filterService
    }
    
    func loadFilter() {
        filter = filterService.fetchFields()
        view?.setSelectedFields()
    }
    
    func saveFilter() {
        filterService.saveFields(filter: filter)
    }
    
    func closeFilter() {
        delegate?.closeFilter()
    }
    
    func clearFilter() {
        filter.order = nil
        filter.contentRating = []
        filter.status = []
        view?.clearSelections()
    }
}
