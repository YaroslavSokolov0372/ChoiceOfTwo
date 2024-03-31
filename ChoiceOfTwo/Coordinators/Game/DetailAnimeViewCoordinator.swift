//
//  DetailAnimeView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/03/2024.
//

import Foundation
import UIKit

class DetailAnimeViewCoordinator: ChildCoordinator {

    
    var viewControllerRef: UIViewController?
    var parent: ParentCoordinator?
    var navigationController: UINavigationController
    
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    func start(gameCardControllerRef: UIViewController?, anime: Anime) {
        let detailInfoAnimeController = DetailInfoAnimeController()
        viewControllerRef = detailInfoAnimeController
        let vm = DetailInfoAnimeVM(isSheet: gameCardControllerRef == nil ? false : true, anime: anime)
        vm.coordinator = self
        detailInfoAnimeController.vm = vm
        if gameCardControllerRef != nil {
            detailInfoAnimeController.modalPresentationStyle = .overCurrentContext
            detailInfoAnimeController.transitioningDelegate = CardTransitionManager.shared
            CardTransitionManager.shared.viewControllerRef = gameCardControllerRef
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.present(detailInfoAnimeController, animated: true)
        } else {
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.pushViewController(detailInfoAnimeController, animated: true)
        }
    }
    

    
    func dismissAsSheet() {
        parent?.popLastAsSheet()
    }
    
    func dismiss() {
        parent?.popLastChildren()
    }
}

