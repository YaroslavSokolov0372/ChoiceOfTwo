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
    
    func dismissAuthScreens(except: Int? = nil, reversed: Bool = true) {
        var index = children.count
        
        for item in children {
            if item is ChildCoordinator {
                let childCoordinator = item as! ChildCoordinator
                
                if except != nil, let except = except {
                    index -= 1
                    if index != except {
                        childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: false)
                        self.childDidFinish(childCoordinator)
                    }
                } else {
                    childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: false)
                    self.childDidFinish(childCoordinator)
                }
            }
        }
    }
}
