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
    
    
    var onMatchedChanges: (() -> Void)?
    
    var matched: [Anime] = [] {
        didSet {
            print("Matched count -", matched.count)
            onMatchedChanges?()
        }
    }
}
