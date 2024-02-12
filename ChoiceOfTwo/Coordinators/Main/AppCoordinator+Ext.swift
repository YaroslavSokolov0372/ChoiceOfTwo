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
        navigationController.setNavigationBarHidden(false, animated: false)
//        authCoordinator.login(navigationController: navigationController, animated: true)

        authCoordinator.entry(navigationController: navigationController, animated: true)
    }
}
