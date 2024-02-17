//
//  RegisterVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import Foundation
import Combine
     
class RegisterVM  {
    
    private let authService = AuthService()
    weak var coordinator: RegisterCoordinator!
    
    @Published var email = TextFieldValidation(textFieldType: .email)
    @Published var password = TextFieldValidation(textFieldType: .password)
    @Published var username = TextFieldValidation(textFieldType: .username)
    
    var subscriptions = Set<AnyCancellable>()
    
    func dismiss() {
        coordinator.dismissScreen()
    }
    
    func goToHome() {
        coordinator.parent?.home()
    }
    
    func signUp(completion: @escaping (_ error: Error?) -> Void) {
        let registerUser = RegisterUserRequest(name: username.text, email: email.text, password: password.text)
        authService.regusterUser(with: registerUser) { authrized, error in
            if let error = error {
                completion(error)
            }
             
            if authrized {
                self.goToHome()
            }
        }
    }
}
