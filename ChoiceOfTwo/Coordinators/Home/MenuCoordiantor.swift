//
//  MenuCoordiantor.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/02/2024.
//

import Foundation
import UIKit

class MenuCoordiantor: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var parent: HomeCoordinator?
    var navigationController: UINavigationController
    
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let menuController = MenuController()
        viewControllerRef = menuController
        let vm = MenuVM()
        vm.coordinator = self
        menuController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(menuController, animated: true)
    }
    
    func searchFriends(friends: [User]) {
        parent?.searchFriends(navigationController: navigationController, animated: true, friends: friends)
    }
    
    func profile(image: UIImage) {
        parent?.profile(navigationController: navigationController, animated: true, image: image)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func dismissHomeScreens() {
        parent?.dismissHomeScreens()
    }
    
    func matcDetail(match: Match) {
        parent?.matchDetail(navigationController: navigationController, animated: true, match: match)
    }
    
    
    func game() {
        parent?.game()
    }
}

