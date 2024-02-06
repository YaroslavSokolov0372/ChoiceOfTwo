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
//        let vc: UIViewController = EntryController()
//        
//        guard var vcCoordinating = vc as? Coordinating  else {
//            print("Failed")
//            return
//        }
//        vcCoordinating.coordinator = self
//        navigationController?.setViewControllers([vc], animated: true)
        print("App Coordinator Start")
        goToEntryPage()
    }
    
    func goToEntryPage() {
        let entryController = EntryController()
        let vm = EntryViewModel()
        vm.coordinator = self
        entryController.entryVM = vm
        navigationController!.pushViewController(entryController, animated: true)
    }
    
    func goToLoginPage() {
        let loginPage = LoginController()
        
        navigationController?.pushViewController(loginPage, animated: true)
    }
}
