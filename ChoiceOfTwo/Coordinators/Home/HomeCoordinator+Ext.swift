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
}
