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
    
    private(set) var matched: [Anime] = []
    
    init(matched: [Anime]) {
        self.matched = matched
    }
}
