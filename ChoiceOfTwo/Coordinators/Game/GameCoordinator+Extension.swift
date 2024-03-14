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
}

