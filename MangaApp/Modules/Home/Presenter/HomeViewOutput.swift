//
//  HomeViewOutput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

import UIKit

protocol HomeViewOutput: AnyObject {
    var popularManga: [Manga] { get }
    var newManga: [Manga] { get }
    var highestRatedManga: [Manga] { get }
    var delegate: HomePresenterOutput? { get set }
    
    func openDetail(manga: Manga)
    func fetchManga()
}
