//
//  ChildrenCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit

protocol ChildCoordinator: Coordinator {
    
    func coordinatorDidFinish() 
    var viewControllerRef: UIViewController? {get set}
}

