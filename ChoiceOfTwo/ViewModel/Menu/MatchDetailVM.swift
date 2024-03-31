//
//  MatchDetail.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/03/2024.
//

import Foundation


class MatchDetailVM {
    
    weak var coordinaator: MatchDetailCoordinator!
    var match: Match!
    
    
    
    func goToDetail(anime: Anime) {
        coordinaator.goToDetail(anime: anime)
    }
    
    func dismiss() {
        coordinaator.dismissScreen()
    }
}
