//
//  AppCoordinator+Ext.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit

extension AppCoordinator {
    func auth() {
        let authCoordinator = AuthCoordinator(navigationController: self.navigationController)
        authCoordinator.parent = self
        navigationController.setNavigationBarHidden(true, animated: false)
//        authCoordinator.login(navigationController: navigationController, animated: true)

        authCoordinator.entry(navigationController: navigationController, animated: true)
    }
    
    
    func home() {
        let homeCoordinator = HomeCoordinator(navigationController: self.navigationController)
        homeCoordinator.parent = self
        navigationController.setNavigationBarHidden(true, animated: false)
        homeCoordinator.menu(navigationController: navigationController, animated: true)
    }
    
    func game() {
        let gameCoordinator = GameCoordinator(navigationController: self.navigationController)
        gameCoordinator.parent = self
        navigationController.setNavigationBarHidden(true, animated: false)
        gameCoordinator.setupGame(navigationController: navigationController, animated: true)
    }
}
