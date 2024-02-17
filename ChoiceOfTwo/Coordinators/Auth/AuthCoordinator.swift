//
//  AuthCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit

class AuthCoordinator: ParentCoordinator {
        
    var parent: AppCoordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    }
    
    func dismissAuthScreens() {
        /// Making sure BaseTabBarViewController's navigation controller is hidden
//        parent?.hideNavigationController()
        
//        let lastCoordinator = children.popLast()
        for item in children.reversed() {
            if item is ChildCoordinator {
                let childCoordinator = item as! ChildCoordinator
//                if let viewController = childCoordinator.viewControllerRef as? DisposableViewController {
//                    viewController.cleanUp()
//                }
                childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: false)
                self.childDidFinish(childCoordinator)
            }
        }
//        lastCoordinator?.popViewController(animated: true, useCustomAnimation: true)
//        navigationController.customPopToRootViewController()
    }

}
