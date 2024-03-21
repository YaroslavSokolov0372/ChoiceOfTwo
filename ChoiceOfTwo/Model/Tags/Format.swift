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

extension [Format.RawValue] {
    
    
    
    func conertFromRawValue() -> [Format] {
        var converted: [Format] = []
        
        for raw in self {
            switch raw {
            case "TV Show":
                converted.append(.tvShow)
            case "Movie":
                converted.append(.movie)
            case "TV Short":
                converted.append(.tvShort)
            case "Special":
                converted.append(.special)
            case "OVA":
                converted.append(.ova)
            case "ONA":
                converted.append(.ona)
            case "Music":
                converted.append(.music)
            default: break
            }
        }
        return converted
    }
}

extension [Format] {
    
    func convertToGraphQL() -> [GraphQLEnum<MediaFormat>?] {
        
        var converted: [GraphQLEnum<MediaFormat>?] = []
        
        for format in self {
            switch format {
            case .tvShort:
                converted.append(.case(.tvShort))
            case .movie:
                converted.append(.case(.movie))
            case .special:
                converted.append(.case(.special))
            case .ova:
                converted.append(.case(.ova))
            case .ona:
                converted.append(.case(.ona))
            case .music:
                converted.append(.case(.music))
            case .tvShow:
                converted.append(.case(.tv))
            }
        }
        
            return converted
    }
}
