//
//  DetailInfoAnimeVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/03/2024.
//

import Foundation

class DetailInfoAnimeVM {
    
    weak var coordinator: DetailAnimeViewCoordinator!
    var isSheet: Bool
    
    private(set) var anime: Anime
    
    init(isSheet: Bool, anime: Anime) {
        self.anime = anime
        self.isSheet = isSheet
    }
    
    func dismissAsSheet() {
        coordinator?.dismissAsSheet()
    }
    
    func dismiss() {
        coordinator?.dismiss()
    }
}
