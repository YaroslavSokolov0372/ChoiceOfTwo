//
//  GameCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import UIKit


class GameCoordinator: ParentCoordinator {
    
    var parent: AppCoordinator?
    var children: [Coordinator] = []
    
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}



