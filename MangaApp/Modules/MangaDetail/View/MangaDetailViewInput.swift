//
//  MangaDetailViewInput.swift
//  MangaApp
//
//  Created by Никита Новицкий on 13.08.2025.
//

protocol MangaDetailViewInput: AnyObject {
    var presenter: MangaDetailViewOutput { get set }
    var manga: Manga? { get set }
}
