//
//  HomeCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/02/2024.
//

import Foundation
import UIKit

class HomeCoordinator: ParentCoordinator {
    
    var parent: AppCoordinator?
    var children: [Coordinator] = []
//    {
        //        didSet {
        //            print("Children count -", children.count)
        //        }
//    }
    
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    
    func dismissHomeScreens() {
        for item in children.reversed() {
            if item is ChildCoordinator {
                let childCoordinator = item as! ChildCoordinator
                if childCoordinator is ProfileCoordinator {
                    childCoordinator.viewControllerRef?.dismiss(animated: true)
                    self.childDidFinish(childCoordinator)
                } else {
                    childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: true)
                    self.childDidFinish(childCoordinator)
                }
            }
        }
    }
}
