//
//  LoginCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit

class LoginCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var parent: AuthCoordinator?
    var navigationController: UINavigationController
    
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let loginController = LoginController()
        viewControllerRef = loginController
        let vm = LoginVM()
        vm.coordinator = self
        loginController.vm = vm
        navigationController.pushViewController(loginController, animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func dismissScreen() {
        parent?.popLastChildren()
    }
}
