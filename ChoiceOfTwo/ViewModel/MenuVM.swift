//
//  MenuVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/02/2024.
//

import Foundation

class MenuVM {
    
    
    weak var coordinator: MenuCoordiantor!
    private var authService = AuthService()
    
    
    
    func dismissHomeScreens() {
        self.coordinator.dismissHomeScreens()
    }
    
    func signOut(completion: @escaping (_ error: Error?) -> Void) {
        authService.signOut { error in
            if let error = error {
                completion(error)
            } else {
                self.coordinator.dismissHomeScreens()
            }
        }
    }
}
