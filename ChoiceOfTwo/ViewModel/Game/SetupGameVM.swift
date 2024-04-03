//
//  SetupGameVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation


class SetupGameVM {
    
    
    weak var coordinator: SetupGameCoordinator!
    private let dBManager = DataBaseManager()
    
    private(set) var genres: [Genre.RawValue] = [] {
        didSet {
            self.onGenresChanges?(genres)
        }
    }

    
    private(set) var formats: [Format.RawValue] = [] {
        didSet {
            self.onFormatsChanges?(formats)
        }
    }
    
    private(set) var playersReady = [String: Bool]() {
        didSet {
            onPlayersReadyChanges?(playersReady)
        }
    }
    
    var onPlayersReadyChanges: (([String: Bool]) -> Void)?
    var onGenresChanges: (([Genre.RawValue]) -> Void)?
    var onSeasonsChanges: (([Season.RawValue]) -> Void)?
    var onFormatsChanges: (([Format.RawValue]) -> Void)?
    var isPlayersCountFirstTimeFetching = true
    
    init() {
        gameInfoListener()
        addPlayerCountListener()
    }
    
    
    //MARK: - Firestore Listeners
    private func gameInfoListener() {
        self.dBManager.addGameInfoListener { info, error in
            if let error = error {
                print("DEBUG: Error with gameInfo Listener", error)
                
            } else {
                if let info = info {
                    self.playersReady = info.ready
                    
                    var formats = [Format.RawValue]()
                    info.formats.forEach { format in
                        formats.append(format.rawValue)
                    }
                    self.formats = formats

                    var genres = [Genre.RawValue]()
                    info.genres.forEach { genre in
                        genres.append(genre.rawValue)
                    }
                    self.genres = genres
                }
            }
        }
    }
    
    private func addPlayerCountListener() {
        self.dBManager.addPlayersListener { count, error in
            if let error = error {
                print("DEBUG: Error with players count listener", error)
            } else {
                print("DEBUG: players count -", count as Any)
                if !self.isPlayersCountFirstTimeFetching {
                    if let count = count {
                        if count == 1 {
                            self.coordinator.dismiss()
                        }
                    }
                }
                self.isPlayersCountFirstTimeFetching = false
            }
        }
    }
    
    public func removePlayerCountListener() {
        self.dBManager.removePlayerCountListener()
    }
    
    public func removeGameInfoListener() {
        self.dBManager.removeGameInfoListener()
    }
     
    //MARK: Firestore&Coordinator
    private func addGenreTag(_ genres: [Genre.RawValue]) {
        self.dBManager.addGenres(genres) { success, error in
            if let error = error {
                print("DEBUG: Error with genre tag", error)
            }
        }
    }
    
    public func preformGenresChanges(_ genre: Genre) {
        var genres = self.genres
        if !self.genres.contains(where: { string in
            return string == genre.rawValue
        }) {
            genres.append(genre.rawValue)
            self.addGenreTag(genres)
        } else {
            let index = self.genres.firstIndex { string in
                return string == genre.rawValue
            }
            genres.remove(at: index!)
            self.addGenreTag(genres)
        }
    }
    
    private func addFormatTag(_ formats: [Format.RawValue]) {
        self.dBManager.addFormats(formats) { success, error in
            if let error = error {
                print("DEBUG: Erro with format tag", error)
            }
        }
    }
    
    public func performFormatChanges(_ format: Format) {
        var formats = self.formats
        if !self.formats.contains(where: { string in
            return string == format.rawValue
        }) {
            formats.append(format.rawValue)
            self.addFormatTag(formats)
        } else {
            let index = self.formats.firstIndex { string in
                return string == format.rawValue
            }
            formats.remove(at: index!)
            self.addFormatTag(formats)
        }
    }
    
    public func changePlayersReadyState(completion: @escaping (Bool) -> Void) {
        self.dBManager.playerReady(self.playersReady) { success, isCurrentPlayerReady, error in
            if let error = error {
                print("DEBUG: Error while changing players ready state", error)
            } else {
                if success {
                    completion(isCurrentPlayerReady)
                    print("DEBUG: Successfully changed players ready state")
                }
            }
        }
    }
     
    public func exitTheGame() {
        self.dBManager.deleteGame { success, error in
            if let error = error {
                print("DEBUG: Failed to delete current game", error)
            } else {
                if success {
                    
                    print("DEBUG: Successfully deleted current game")
                }
            }
        }
    }
    
    public func goCardGame() {
        self.coordinator.cardGame()
    }
}
