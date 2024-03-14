//
//  AnimeApiService.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import Apollo
import AnimeAPI


class AnimeApiService {
    
    //    static let shared = AnimeApiService()
    
    private(set) var apollo = ApolloClient(url: URL(string: "https://graphql.anilist.co")!)
    
}
