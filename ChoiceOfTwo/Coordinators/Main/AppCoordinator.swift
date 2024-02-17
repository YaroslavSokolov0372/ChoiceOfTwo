//
//  AppCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation


import UIKit
 
class AppCoordinator: ParentCoordinator {

    
    
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let launchInstruction = LaunchInstructor.configure()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        print("App Coordinator Start")
        switch launchInstruction {
        case .auth:
            auth()
            return
        case .home:
            auth()
            home()
            return
        }
    }
}
 
