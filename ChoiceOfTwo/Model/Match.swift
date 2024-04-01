//
//  history.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/03/2024.
//

import Foundation


struct Match {
    let skipped: [Anime]
    let matched: [Anime]
    let genres: [Genre.RawValue]
    let formats: [Format.RawValue]
    let playedWithUID: String
    let playersName: String
}
