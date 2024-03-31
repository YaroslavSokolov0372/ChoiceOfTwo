//
//  MatchDetailCoordinator.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/03/2024.
//

import Foundation
import UIKit

class MatchDetailCoordinator: ChildCoordinator {
    
    var viewControllerRef: UIViewController?
    var parent: HomeCoordinator?
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func start(match: Match) {
        let matchController = MatchDetailController()
        viewControllerRef = matchController
        let vm = MatchDetailVM()
        vm.coordinaator = self
        vm.match = match
        matchController.vm = vm
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(matchController, animated: true)
    }
    
    func dismissScreen() {
        parent?.popLastChildren()
    }
    
    func goToDetail(anime: Anime) {
        parent?.animeDetail(navigationController: navigationController, animated: true, anime: anime)
    }
}
