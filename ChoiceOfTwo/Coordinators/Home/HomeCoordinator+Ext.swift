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
    
    func profile(navigationController: UINavigationController, animated: Bool) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.parent = self
        addChild(profileCoordinator)
        profileCoordinator.start()
    }
    
    func searchFriends(navigationController: UINavigationController, animated: Bool) {
        let searchFriendsCoordinator = SearchFriendsCoordinator(navigationController: navigationController)
        searchFriendsCoordinator.parent = self
        addChild(searchFriendsCoordinator)
        searchFriendsCoordinator.start()
    }
}