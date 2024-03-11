//
//  SearchFriendsCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation
import UIKit


class SearchFriendsCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var parent: HomeCoordinator?
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func start(friends: [User]) {
        let searchFController = SearchFriendsController()
        viewControllerRef = searchFController
        let vm = SearchFriendsVM()
        
        vm.friends = friends
        vm.coordinator = self
        searchFController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.present(searchFController, animated: true)
    }
    
    func dismissScreen() {
        parent?.popLastAsSheet()
    }
}
