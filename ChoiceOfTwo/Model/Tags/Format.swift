//
//  Format.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import AnimeAPI

enum Format: String, CaseIterable, Codable, StringRepresentable {
    
//    typealias StringEnumType = Genre
    
    case tvShow = "TV Show"
    case movie = "Movie"
    case tvShort = "TV Short"
    case special = "Special"
    case ova = "OVA"
    case ona = "ONA"
    case music = "Music"
}

extension Format {
    func convertedSeason() -> GraphQLEnum<MediaFormat> {
        switch self {
        case .tvShow:
            return .case(.tv)
        case .movie:
            return .case(.movie)
        case .tvShort:
            return .case(.tvShort)
        case .special:
            return .case(.special)
        case .ova:
            return .case(.ova)
        case .ona:
            return .case(.ona)
        case .music:
            return .case(.music)
        }
    }
}
