//
//  LoginVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import Foundation
import Combine

class LoginVM {
    
    weak var coordinator: LoginCoordinator!
    private var authService = AuthService()
    
    @Published var email = TextFieldValidation(textFieldType: .email)
    @Published var password = TextFieldValidation(textFieldType: .password)
    
    var subscriptions = Set<AnyCancellable>()
    
    func dismiss() {
        coordinator.dismissScreen()
    }
    
    func goToHome() {
        coordinator.goHome()
    }
    
    func signIn(completion: @escaping (_ error: Error?) -> Void) {
        authService.signIn(with: RegisterUserRequest(name: nil, email: email.text, password: password.text)) { error in
            if let error = error {
                completion(error)
            } else {
                self.goToHome()
            }
        }
    }
}



