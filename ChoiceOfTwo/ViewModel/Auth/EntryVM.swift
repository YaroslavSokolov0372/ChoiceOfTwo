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
    
    func goToHome() {
        coordinator.parent?.home()
    }
    
    func signInWithGoogle(viewController: UIViewController, completion: @escaping (_ error: Error) -> Void) {
        authService.registerWithGoogle(viewController: viewController) { authorized, error in
            if let error = error {
                completion(error)
            }
            if authorized {
                self.goToHome()
            }
        }
    }
}
