//
//  CardGameVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/03/2024.
//

import Foundation
import  UIKit

class CardGameVM {
    
    let animeApi = AnimeApiService()
    weak var coordinator: CardGameCoordinator!
    
    var currentPage: Int = 1
    var genres: [Genre.RawValue] = []
    var formats: [Format.RawValue] = []
    var season: [Season] = []
    
    var onAnimeListChange: (() -> Void)?
    var onAnimeListError: ((Error) -> Void)?
    private(set) var animeList: [Anime] = [] {
        didSet {
            onAnimeListChange?()
            print("Anime count in vm -", animeList.count)
        }
    }
    
    func detailView(anime: Anime) {
        self.coordinator.detailView(anime: anime)
    }
    
    func fetchAnimes() {
        animeApi.fetchAnimeWith(currentPage: currentPage, genres: genres, formats: formats.conertFromRawValue()) { animeList, error in
            if let error = error {
                self.onAnimeListError?(error)
                print("Error", error)
            } else {
                print("Successfully fetched anime")
                if let animeList = animeList {
                    self.animeList = animeList
                }
            }
        }
    }
}
