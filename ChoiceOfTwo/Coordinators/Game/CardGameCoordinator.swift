//
//  CardGameCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/03/2024.
//

import Foundation
import UIKit

class CardGameCoordinator: ChildCoordinator {

    
    
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
    
    func start() {
        let cardGameController = CardGameController()
        viewControllerRef = cardGameController
        let vm = CardGameVM()
        vm.coordinator = self
        cardGameController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(cardGameController, animated: true)
    }
    

    
    func dismiss() {
        parent?.popLastChildren()
    }
}
