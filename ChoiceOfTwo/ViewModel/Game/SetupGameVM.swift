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
            self.addGenreTag(genres)
//            self.onGenresChanges?(genres)
        }
    }
    var onGenresChanges: (([Genre.RawValue]) -> Void)?
    var listenerCheck: Int = 0
//    {
//        didSet {
//            if listenerCheck % 2 == 0 {
//                
//            }
//        }
//    }
    
    init() {
        gameInfoListener()
    }
    
    private func gameInfoListener() {
        self.dBManager.addGameInfoListener { info, error in
            
            if let error = error {
                print("DEBUG: Error with gameInfo Listener", error)
            } else {
                if let info = info {
//                    self.listenerCheck += 1
//                    print("listener check", self.listenerCheck)
//                    if self.listenerCheck % 2 == 0 {
//                        self.genres = info.genres.map({ $0.rawValue })
                    self.onGenresChanges?(self.genres)
                        print(info.genres)
//                    }

                }
            }
        }
    }
    
    public func addGenreTag(_ genres: [Genre.RawValue]) {
        self.dBManager.addGenres(genres) { success, error in
            if let error = error {
                print("DEBUG: Error with genre tag", error)
            } else {
                if success {
                    print("Successfully changed genre tag")
//                    self.onGenresChanges?(genres)
                }
            }
        }
    }
    
    public func preformGenresChanges(_ genre: Genre) {
        if !self.genres.contains(where: { string in
            return string == genre.rawValue
        }) {
            self.genres.append(genre.rawValue)
        } else {
            let index = self.genres.firstIndex { string in
                return string == genre.rawValue
            }
            self.genres.remove(at: index!)
        }
    }
}
