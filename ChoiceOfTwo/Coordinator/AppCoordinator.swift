//
//  AppCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/02/2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?
    private let launchInstruction = LaunchInstructor.configure()
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        print("App Coordinator Start")
        
        switch launchInstruction {
        case .auth:
            goToEntryPage()
            return
        case .home:
            goToEntryPage()
            return
        }
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
    
    func goToRegisterPage() {
        let registerController = RegisterController()
        let vm = RegisterVM()
        vm.coordinator = self
        registerController.vm = vm
        navigationController?.pushViewController(registerController, animated: true)
    }
    
}
