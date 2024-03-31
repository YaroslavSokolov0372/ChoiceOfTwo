//
//  GameCoordinator+Extensions.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import UIKit


extension GameCoordinator {
    func setupGame(navigationController: UINavigationController, animated: Bool) {
        let setupCoordinator = SetupGameCoordinator(navigationController: navigationController)
        setupCoordinator.parent = self
        addChild(setupCoordinator)
        setupCoordinator.start()
    }
    
//    func cardGame(navigationControlle: UINavigationController, animated: Bool, genres: [Genre.RawValue], formats: [Format.RawValue]) {
    func cardGame(navigationControlle: UINavigationController, animated: Bool) {
        let cardGameCoordinator =  CardGameCoordinator(navigationController: navigationController)
        cardGameCoordinator.parent = self
        addChild(cardGameCoordinator)
//        cardGameCoordinator.start(genres: genres, formats: formats)
        cardGameCoordinator.start()
    }
    
    func detailView(gameCardControllerRef: UIViewController?, anime: Anime, navigationController: UINavigationController, animeted: Bool) {
        let detailCoordinator =  DetailAnimeViewCoordinator(navigationController: navigationController)
        detailCoordinator.parent = self
        addChild(detailCoordinator)
        detailCoordinator.start(gameCardControllerRef: gameCardControllerRef, anime: anime)
    }
    
    func matched(navigationController: UINavigationController, animated: Bool, matched: [Anime]) {
        let matchedCoordinator = MatchedCoordinator(navigationController: navigationController)
        matchedCoordinator.parent = self
        addChild(matchedCoordinator)
        matchedCoordinator.start(matched: matched)
    }
}

