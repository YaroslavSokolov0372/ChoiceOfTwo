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
    
    func start(image: UIImage) {
        let profileCoorinator = ProfileController()
        profileCoorinator.circleImage.image = image
        viewControllerRef = profileCoorinator
        let vm = ProfileVM()
        vm.coordinator = self
        profileCoorinator.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.present(profileCoorinator, animated: true)
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func dismissScreen() {
        parent?.popLastAsSheet()
    }
    
    func dismissHomeScreens() {
        parent?.dismissHomeScreens()
    }
}
