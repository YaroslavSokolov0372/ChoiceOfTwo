//
//  RegisterProfImageVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 01/03/2024.
//

import Foundation
import UIKit


class RegisterProfImageVM {
    
    weak var coordinator: RegisterProfImageCoordinator!
    
    
    func goToCropImage(image: UIImage) {
        coordinator.goToCropImage(image: image)
    }
    
    func dismiss() {
        coordinator.dismissScreen()
    }
    
    
    
    func goToHomePage() {
        coordinator.parent?.home()
    }
}
