//
//  ChooseProfileImageCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 01/03/2024.
//

import Foundation
import UIKit

class RegisterProfImageCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var parent: AuthCoordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func setupImage(image: UIImage) {
        guard let viewControllerRef = viewControllerRef as? RegisterProfImageController else {
            return
        }
        viewControllerRef.setupImage(image: image)
    }
    
    
    func start() {
        let registerController = RegisterProfImageController()
        viewControllerRef = registerController
        let vm = RegisterProfImageVM()
        vm.coordinator = self
        registerController.vm = vm
        navigationController.pushViewController(registerController, animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func dismissScreen() {
        parent?.popLastChildren()
    }
    
    func goToCropImage(image: UIImage) {
        parent?.cropImage(navigationController: navigationController, animater: true, image: image)
    }
}
