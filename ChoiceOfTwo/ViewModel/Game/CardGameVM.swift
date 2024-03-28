//
//  CardGameVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/03/2024.
//

import Foundation
import  UIKit

class CardGameVM {
    
    let animeApi = AnimeApiService()
    weak var coordinator: CardGameCoordinator!
    private let dBManager = DataBaseManager()
    
    
    
    var currentPage: Int = 1
    var genres: [Genre.RawValue]? = nil
    var formats: [Format.RawValue]? = nil
    private(set) var likedAnimes: [Anime] = [] {
        didSet {
            likedAnimes.forEach { anime in
                if friendsLiked.contains(anime) {
                    let matched = likedAnimes.firstIndex(where: { $0.title == anime.title })
                    if !self.matched.contains(anime) {
                        self.matched.append(likedAnimes[matched!])
                    }
                }
            }
        }
    }
    private(set) var skippedAnimes: [Anime] = []
    
    private(set) var friendsLiked: [Anime] = [] {
        didSet {
            print(friendsLiked.count)
            friendsLiked.forEach { anime in
                if likedAnimes.contains(anime) {
                    let matched = likedAnimes.firstIndex(where: { $0.title == anime.title })
                    if !self.matched.contains(anime) {
                        self.matched.append(likedAnimes[matched!])
                    }
                }
            }
        }
    }
    
    var onMatchedChanged: (() -> Void)?
    private(set) var matched: [Anime] = [] {
        didSet {
//            print("DEBUG: - Match Animes:", matched.count)
            if !matched.isEmpty {
                onMatchedChanged?()
            }
        }
    }
    
    var onListenerError: ((Error) -> Void)?
    var numOfGamesBegoreFinish: Int? = nil {
        didSet {
            print("DEBUG: numOfGames count", self.numOfGamesBegoreFinish)
        }
    }
    
    init() {
        addFriendLikedListener()
        addFinishListener()
        fetchTags()
        fetchLiked()
    }
    
    var onAnimeListChange: ((Int) -> Void)?
    var onAnimeListError: ((Error) -> Void)?
    private(set) var animeList: [Anime] = [] {
        didSet {
            onAnimeListChange?(animeList.count)
            print("Anime count in vm -", animeList.count)
        }
    }
    
    private func addFriendLikedListener() {
        self.dBManager.addFriendsLikedListener { liked, error in
            if let error = error {
                print("DEBUG: Failed to get liked of snapshot listener", error)
            } else {
                if let animes = liked {
                    self.friendsLiked = animes
                    print("DEBUG: Successfully got friends liked")
                }
            }
        }
    }
    
    private func addFinishListener() {
        self.dBManager
            .addFinishGameListener { numOfGames, error in
                if let error = error {
                    print("DEBUG: Error with history matches count listener", error)
                } else {
                    if let numOfGames = numOfGames {
                        print("DEBUG: Successfully with history matches count listener", numOfGames)
                        if self.numOfGamesBegoreFinish == nil {
                            self.numOfGamesBegoreFinish = numOfGames
                        } else {
                            if self.numOfGamesBegoreFinish! < numOfGames {
                                guard let coordinator = self.coordinator else {
                                    print("Coordinator is nil")
                                    return
                                }
                                //                                self.coordinator.removeAllChildrens()
                                coordinator.removeAllChildrens()
                            }
                        }
                    }
                }
            }
    }
    
    private func fetchLiked() {
        self.dBManager.fetchLiked { animes, error in
            if let error = error {
                print("DEBUG: Error while fetching liked", error)
            } else {
                if let animes = animes {
                    self.likedAnimes = animes
                }
            }
        }
    }
    
    private func fetchTags() {
        self.dBManager.fetchTags { tags, error in
            
            if let error = error {
                print("Failed to fetch tags for currentGame", error)
            } else {
                if let tags = tags {
                    print("DEBUG: - Genres array -", tags.0)
//                    print("DEBUG: - Formats array -", tags.1)
                    self.genres = tags.0
                    self.formats = tags.1
                    self.fetchAnimes(onceAgainOnFailed: true, genres: tags.0, formats: tags.1)
                }
            }
        }
    }
    
    func detailView(anime: Anime) {
        self.coordinator.detailView(anime: anime)
    }
    
    func goToMatched() {
        self.coordinator.goToMatched(matched: self.matched)
    }
    
    func cleanCoordinatorIfNeeded() {
        self.coordinator.removeOthers()
    }
    
    func fetchAnimes(onceAgainOnFailed: Bool, genres: [Genre.RawValue]? = nil, formats: [Format.RawValue]? = nil) {
        //        print("Genres -", genres)
        //        print(formats)
        animeApi.fetchAnimeWith(
            currentPage: currentPage,
            genres: genres == nil ? self.genres! : genres!,
            formats: formats == nil ? self.formats!.conertFromRawValue() : formats!.conertFromRawValue()) { animeList, error in
                if let error = error {
//                    self.onAnimeListError?(error)
                    
                    print("Error", error)
                    if onceAgainOnFailed {
//                        self.onAnimeListError?(error)
                        self.fetchAnimes(onceAgainOnFailed: false)
                    } else {
                        self.onAnimeListError?(error)
                        //TODO: - Show message to recreate a game
                    }
                } else {
                    print("Successfully fetched anime")
                    if let animeList = animeList {
                        self.currentPage += 1
                        self.animeList = animeList
                    }
                }
            }
    }
    
    func finishGame() {
        self.dBManager.finishGame(
            matchedAnimes: matched) { finished, error in
                if let error = error {
                    print("Failed to finish the game", error)
                } else {
                    if finished == true {
                        print("Successfully added game to a history and deleted current game")
//                        self.coordinator.removeAllChildrens()
                    }
                }
            }
    }
    
    func writeSkipped(anime: Anime) {
        
        self.dBManager.skippedAnime(anime) { success, error in
            if let error = error {
                print("Error while writing liked animes in firestore", error)
            } else {
                if success != nil, success == true {
                    print("Successfully skipped liked anime to a list")
                }
            }
        }
    }
    
    func writeLikedAnimes(anime: Anime) {
        self.dBManager.likedAnime(anime) { success, error in
            if let error = error {
                print("Error while writing liked animes in firestore", error)
            } else {
                if success != nil, success == true {
                    self.likedAnimes.append(anime)
                    print("Successfully added liked anime to a list")
                }
            }
        }
    }
}
