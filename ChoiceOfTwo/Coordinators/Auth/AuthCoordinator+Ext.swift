//
//  AuthCoordinator+Ext.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit


extension AuthCoordinator {
    
    
    func entry(navigationController: UINavigationController, animated: Bool) {
        let entryCoordinator = EntryCoordinator(navigationController: navigationController)
        entryCoordinator.parent = self
        addChild(entryCoordinator)
        entryCoordinator.start()
    }
    
    func login(navigationController: UINavigationController, animated: Bool) {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parent = self
        addChild(loginCoordinator)
        loginCoordinator.start()
    }
    
    func register(navigationController: UINavigationController, animated: Bool) {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.parent = self
        addChild(registerCoordinator)
        registerCoordinator.start()
    }
    
    func registerProfImage(navigationController: UINavigationController, animater: Bool) {
        let profImageCoordinator = RegisterProfImageCoordinator(navigationController: navigationController)
        profImageCoordinator.parent = self
        addChild(profImageCoordinator)
        profImageCoordinator.start()
    }
    
    func cropImage(navigationController: UINavigationController, animater: Bool, image: UIImage) {
        let profImageCoordinator = CropImageCoordinator(navigationController: navigationController)
        profImageCoordinator.parent = self
        addChild(profImageCoordinator)
        profImageCoordinator.start(image: image)
    }
    
    
    func home() {
        parent?.home()
    }
}
