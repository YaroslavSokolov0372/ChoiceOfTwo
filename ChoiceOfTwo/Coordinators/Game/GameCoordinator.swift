//
//  GameCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import UIKit


class GameCoordinator: ParentCoordinator {
    
    var parent: AppCoordinator?
    var children: [Coordinator] = []
    
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func dismissGameScreens() {
        for item in children.reversed() {
            if item is ChildCoordinator {
                let childCoordinator = item as! ChildCoordinator
                childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: true)
                self.childDidFinish(childCoordinator)
            }
        }
    }
    
//    func removeAllExeptLast() {
//        var count = children.count
//        print("COUNT", count)
////        if count != 1 {
//            for item in children {
//                if item is ChildCoordinator {
//                    if count != 1 {
//                        let childCoordinator = item as! ChildCoordinator
//                        childCoordinator.viewControllerRef?.navigationController?.popViewController(animated: false)
//                        self.childDidFinish(childCoordinator)
//                        count -= 1
//                    }
//                }
////            }
//        }
//    }
}



    
