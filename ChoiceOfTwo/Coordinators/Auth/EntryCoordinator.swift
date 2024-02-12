//
//  AuthCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit

class EntryCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var parent: AuthCoordinator?
    var navigationController: UINavigationController
    
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let entryController = EntryController()
        viewControllerRef = entryController
        let vm = EntryVM()
        vm.coordinator = self
        entryController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(entryController, animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func register() {
        parent?.register(navigationController: navigationController, animated: true)
    }
    
    func login() {
        parent?.login(navigationController: navigationController, animated: true)
    }
}
