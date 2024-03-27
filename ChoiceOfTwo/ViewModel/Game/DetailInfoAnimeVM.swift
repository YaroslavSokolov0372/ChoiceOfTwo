//
//  DetailInfoAnimeVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/03/2024.
//

import Foundation

class DetailInfoAnimeVM {
    
    weak var coordinator: DetailAnimeViewCoordinator!
    
    private(set) var anime: Anime
    
    init(anime: Anime) {
        self.anime = anime
    }
    
    func dismiss() {
        coordinator?.dismiss()
    }
}
