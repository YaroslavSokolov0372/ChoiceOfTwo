//
//  RootCoordinatorProtocol.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit


protocol ParentCoordinator: Coordinator {
    
    var children: [Coordinator] { get set }

    func addChild(_ child: Coordinator?)
    
    func childDidFinish(_ child: Coordinator?)
    
    func popLastChildren()
    
    func popLastAsSheet()
}


extension ParentCoordinator {
    
    func addChild(_ child: Coordinator?){
        if let _child = child {
            children.append(_child)
        }
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
                break
            }
        }
    }
    
    func popLastChildren() {
        if !children.isEmpty {
            let lastCoordinator = children.last as! ChildCoordinator
            lastCoordinator.viewControllerRef?.navigationController?.popViewController(animated: true)
            self.childDidFinish(lastCoordinator)
        }
    }
    
    func popToViewRoot() {
        if !children.isEmpty {
            let lastCoordinator = children.last as! ChildCoordinator
            lastCoordinator.viewControllerRef?.navigationController?.popToRootViewController(animated: true)
            self.childDidFinish(lastCoordinator)
        }
    }
    
    
    
    func popLastAsSheet() {
        if !children.isEmpty {
            let lastCoordinator = children.last as! ChildCoordinator
            lastCoordinator.viewControllerRef?.dismiss(animated: true)
            self.childDidFinish(lastCoordinator)
        }
    }
}
