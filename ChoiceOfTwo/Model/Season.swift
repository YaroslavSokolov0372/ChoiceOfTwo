//
//  Season.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import AnimeAPI


enum Season: String, CaseIterable {
    case winter = "Winter"
    case summer = "Summer"
    case spring = "Spring"
    case fall = "Fall"
}


extension Season {
    func convertSeason() -> GraphQLEnum<MediaSeason> {
        switch self {
        case .winter:
            return .case(.winter)
        case .summer:
            return .case(.summer)
        case .spring:
            return .case(.spring)
        case .fall:
            return .case(.fall)
        }
    }
}
