//
//  GameInfo.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 16/03/2024.
//

import Foundation

struct GameInfo: Codable {
    
    var ready: [String: Bool]
    var genres: [Genre]
    var formats: [Format]
    var seasons: [Season]
    
}
