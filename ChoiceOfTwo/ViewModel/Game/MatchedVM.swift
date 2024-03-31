//
//  MatchedVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 24/03/2024.
//

import Foundation


class MatchedVM {
    
    weak var coordinator: MatchedCoordinator!
    
    
    func dimiss() {
        coordinator.dismiss()
    }
    
    func goToDetail(anime: Anime) {
        coordinator.goToDetail(anime: anime)
    }
    
    
    var onMatchedChanges: (() -> Void)?
    
    var matched: [Anime] = [] {
        didSet {
            print("Matched count -", matched.count)
            onMatchedChanges?()
        }
    }
}
