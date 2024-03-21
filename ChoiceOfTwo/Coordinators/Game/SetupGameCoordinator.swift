//
//  SetupGameCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import UIKit

class SetupGameCoordinator: ChildCoordinator {

    
    
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
        let setupGameController = SetupGameController()
        viewControllerRef = setupGameController
        let vm = SetupGameVM()
        vm.coordinator = self
        setupGameController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(setupGameController, animated: true)
    }
    
    func cardGame(genres: [Genre.RawValue], formats: [Genre.RawValue]) {
        parent?.cardGame(navigationControlle: navigationController, animated: true, genres: genres, formats: formats)
    }
    
    func dismiss() {
        parent?.popLastChildren()
    }
}
