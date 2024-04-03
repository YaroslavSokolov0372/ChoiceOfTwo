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
    
    func dismissGameScreens() {
        for item in children.reversed() {
            if item is ChildCoordinator {
                let childCoordinator = item as! ChildCoordinator
                childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: true)
                self.childDidFinish(childCoordinator)
            }
        }
    }
}



    
