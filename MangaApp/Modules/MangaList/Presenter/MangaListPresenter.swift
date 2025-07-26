//
//  MangaListPresenter.swift
//  MangaApp
//
//  Created by Никита Новицкий on 03.08.2025.
//

import Foundation

// TODO: Убрать отсюда
enum ViewState {
    case isFetching, isSuccess, isError, isEndReached
}

protocol MangaListPresenterOutput: AnyObject {
    func didTapFilter(onApply: @escaping () -> Void)
    func openDetail(manga: Manga)
}

class MangaListPresenter: MangaListViewOutput {
    var mangas: [Manga] = []
    var filter = Filter()
    var state = ViewState.isFetching {
        didSet {
            view?.updateUI(state: state)
        }
    }
    
    private let mangaService: MangaServiceProtocol
    private let filterService: FilterServiceProtocol
    private let historyService: HistoryServiceProtocol
    
    weak var view: MangaListViewInput?
    weak var delegate: MangaListPresenterOutput?
    
    init(mangaService: MangaServiceProtocol, filterService: FilterServiceProtocol, historyService: HistoryServiceProtocol) {
        self.mangaService = mangaService
        self.filterService = filterService
        self.historyService = historyService
    }
    
    func openFilter(onApply: @escaping () -> Void) {
        delegate?.didTapFilter(onApply: onApply)
    }
    
    func openDetail(index: Int) {
        delegate?.openDetail(manga: mangas[index])
    }
    
    func fetchFilterFields() {
        filter = filterService.fetchFields()
        view?.setFilter(filter: filterService.fetchFields())
    }
    
    func saveFilter() {
        filterService.saveFields(filter: filter)
        if let search = filter.search {
            historyService.addRequest(text: search)
        }
    }
    
    func fetchMangas() {
        state = .isFetching

        mangaService.fetchMangas(filter: filter) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let mangas):
                    if self.filter.offset == 0 {
                        self.mangas.removeAll()
                    }
                    let existingIDs = Set(self.mangas.map { $0.id })
                    let uniqueNewMangas = mangas.filter { !existingIDs.contains($0.id) }
                    
                    self.mangas.append(contentsOf: uniqueNewMangas)
                    self.state = mangas.count < self.filter.limit ? .isEndReached : .isSuccess
                case .failure(let err):
                    self.state = .isError
                }
            }
        }
        return
        
        let rnd = Int.random(in: 0...2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            
            if rnd == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let tempManga = self.filter.offset == 0 ? [
                        Manga(id: "0", title: "Call of the night", description: "СДВГ, или синдром дефицита внимания и гиперактивности, у взрослых проявляется иначе, чем у детей, но его влияние на жизнь может быть не менее значительным. Это расстройство мешает эффективно справляться с повседневными задачами, создает сложности в эмоциональной сфере и профессиональной деятельности.Например, взрослый с СДВГ может испытывать трудности в управлении домашним хозяйством: забыть оплатить счета, откладывать визиты к врачу или путаться в графике встреч. Эти проблемы могут накапливаться, вызывая чувство вины, стресса и утраты контроля над ситуацией.Синдром может оставаться незамеченным в течение многих лет, особенно если его симптомы незначительно проявлялись в детстве. Нередко взрослые объясняли свои трудности преодолением стресса или усталости, не осознавая, что дело в нарушениях внимания и самоконтроля.Современные исследования показывают, что в основе СДВГ происходят биохимические изменения в мозге, связанные с недостаточной выработкой дофамина. Этот нейромедиатор отвечает за мотивацию, удовольствие и способность сосредотачиваться. Люди с СДВГ часто чувствуют себя «застрявшими», не могут начать работу над проектом или завершить начатое дело, что приводит к разочарованию в себе.", coverImageURL: "https://cdn.rafled.com/anime-icons/images/iWW9c1VjhALFAWMhNLsQ3VdPojw0O9J7.jpg",
                              characteristics: [
                                "year": "2014",
                                "status": "ongoing",
                                "content rating": "safe",
                              ]
                             ),
                        Manga(id: "1", title: "JOJO Bizzare Adventure: Golden Ocean", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "2", title: "Sun", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpgd"),
                        Manga(id: "3", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "4", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "5", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "6", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "7", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "8", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "9", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "10", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "11", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "12", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "13", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                        Manga(id: "14", title: "Title 1", description: "df", coverImageURL: "https://m.media-amazon.com/images/I/81MMBp4FTlL.jpg"),
                    ] : [
                        Manga(id: "15", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "16", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "17", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "18", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "19", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "21", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "22", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "23", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "24", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                        Manga(id: "25", title: "Call of the night", description: "df", coverImageURL: "https://i.pinimg.com/1200x/2f/55/ee/2f55ee808bb6d551dff05bfc7de80990.jpg"),
                    ]
                    // TODO: сморим на результирующее количество, если оно меньше чем limit, то перестаем делать запросы (меняем внутренний флаг)
                    if self.filter.offset == 0 {
                        self.mangas.removeAll()
                    }
                    self.mangas.append(contentsOf: tempManga)
                    self.mangas = NSOrderedSet(array: self.mangas).array as! [Manga]
                    self.state = tempManga.count < self.filter.limit ? .isEndReached : .isSuccess

                }
            } else if rnd == 1 {
                
                self.state = .isError
            } else if rnd == 2 {
                self.state = .isSuccess
                self.mangas = []
                
                return
                //            if self.filter.offset == 0 {
                //                self.mangas.removeAll()
                //            }
                //self.state = .isSuccess
                //self.mangas.append(contentsOf: [])
                //self.mangas = NSOrderedSet(array: self.mangas).array as! [Manga]
                //self.view?.setMangas(mangas: self.mangas)
            }
        }
    }
    
    func goToMangasSearch() {
        
    }
}
