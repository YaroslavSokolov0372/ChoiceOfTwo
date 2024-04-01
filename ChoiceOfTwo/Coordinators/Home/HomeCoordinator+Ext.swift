//
//  HomeCoordinator+Ext.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/02/2024.
//

import Foundation
import UIKit

extension HomeCoordinator {
    
    func menu(navigationController: UINavigationController, animated: Bool) {
        let menuCoordinator = MenuCoordiantor(navigationController: navigationController)
        menuCoordinator.parent = self
        addChild(menuCoordinator)
        menuCoordinator.start()
    }
    
    func profile(navigationController: UINavigationController, animated: Bool, image: UIImage) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.parent = self
        addChild(profileCoordinator)
        profileCoordinator.start(image: image)
    }
    
    func searchFriends(navigationController: UINavigationController, animated: Bool, friends: [User]) {
        let searchFriendsCoordinator = SearchFriendsCoordinator(navigationController: navigationController)
        searchFriendsCoordinator.parent = self
        addChild(searchFriendsCoordinator)
        searchFriendsCoordinator.start(friends: friends)
    }
    
    func matchDetail(navigationController: UINavigationController, animated: Bool, match: Match) {
        let matchDetailCoordinator = MatchDetailCoordinator(navigationController: navigationController)
        matchDetailCoordinator.parent = self
        addChild(matchDetailCoordinator)
        matchDetailCoordinator.start(match: match)
    }
    
    func animeDetail(navigationController: UINavigationController, animated: Bool, anime: Anime) {
        let detailCoordinator =  DetailAnimeViewCoordinator(navigationController: navigationController)
        detailCoordinator.parent = self
        addChild(detailCoordinator)
        detailCoordinator.start(gameCardControllerRef: nil, anime: anime)
    }
    
    func game() {
        parent?.game()
    }
}
