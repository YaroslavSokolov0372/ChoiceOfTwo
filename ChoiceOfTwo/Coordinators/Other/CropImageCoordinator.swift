//
//  CropImageCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 01/03/2024.
//

import Foundation
import UIKit

class CropImageCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var navigationController: UINavigationController
    var parent: ParentCoordinator?
    func coordinatorDidFinish() {
        
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(image: UIImage) {
        let registerController = FinalCropImageController()
        viewControllerRef = registerController
        let vm = CropImageVM()
        vm.coordinator = self
        vm.image = image
        registerController.vm = vm
        navigationController.pushViewController(registerController, animated: true)
    }
}
