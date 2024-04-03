//
//  ProfileVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 18/02/2024.
//

import Foundation
import UIKit

class ProfileVM {
    
     weak var coordinator: ProfileCoordinator!
    private let authService = AuthService()
    private let dBManager = DataBaseManager()
     
    func dismiss() {
        coordinator.dismissScreen()
    }
    
    public func signOut(completion: @escaping (_ error: Error?) -> Void) {
        authService.signOut { error in
            if let error = error {
                completion(error)
            } else {
                self.coordinator.parent?.popToViewRoot()
            }
        }
    }
    
    public func dismissHomeScreens() {
        self.coordinator.dismissHomeScreens()
    }
}
