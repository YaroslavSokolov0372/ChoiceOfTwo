//
//  EntryViewModel.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import Foundation
import UIKit

class EntryVM {
    
    private let authService = AuthService()
    weak var coordinator: EntryCoordinator!
    
    func goToLogin() {
        coordinator.login()
    }
    
    func goToRegister() {
        coordinator.register()
    }
    
    func signInWithGoogle(viewController: UIViewController) {
        authService.registerWithGoogle(viewController: viewController) { bool, error in
            
        }
    }
}
