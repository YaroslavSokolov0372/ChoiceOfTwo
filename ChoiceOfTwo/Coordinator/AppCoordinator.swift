//
//  AppCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("App Coordinator Start")
        goToEntryPage()
    }
    
    func goToEntryPage() {
        let entryController = EntryController()
        let vm = EntryVM()
        vm.coordinator = self
        entryController.vm = vm
        navigationController!.pushViewController(entryController, animated: true)
    }
    
    func goToLoginPage() {
        let loginController = LoginController()
        let vm = LoginVM()
        vm.coordinator = self
        loginController.vm = vm
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    func goTORegisterPage() {
        let registerController = RegisterController()
        let vm = RegisterVM()
        vm.coordinator = self
        registerController.vm = vm
        navigationController?.pushViewController(registerController, animated: true)
    }
}
