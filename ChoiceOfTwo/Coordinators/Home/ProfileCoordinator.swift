//
//  ProfileCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation
import UIKit

class ProfileCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var parent: HomeCoordinator?
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchFController = ProfileController()
        viewControllerRef = searchFController
        let vm = ProfileVM()
        vm.coordinator = self
        searchFController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.present(searchFController, animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func dismissScreen() {
        parent?.popLastAsSheet()
    }
}
