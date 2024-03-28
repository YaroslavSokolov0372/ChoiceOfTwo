//
//  MatchedCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 24/03/2024.
//

import Foundation
import UIKit

class MatchedCoordinator: ChildCoordinator {
    
    
    var viewControllerRef: UIViewController?
    var parent: GameCoordinator?
    var navigationController: UINavigationController
    
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func start(matched: [Anime]) {
        let matchedController = MatchedController()
        viewControllerRef = matchedController
        //        let vm = MatchedVM(matched: matched)
        let vm = MatchedVM()
        vm.matched = matched
        vm.coordinator = self
        matchedController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(matchedController, animated: true)
    }
    
    func dismiss() {
        parent?.popLastChildren()
    }
}
