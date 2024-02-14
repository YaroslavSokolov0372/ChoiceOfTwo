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
    
    @Published var email = TextFieldValidation(textFieldType: .email)
    @Published var password = TextFieldValidation(textFieldType: .password)
    
    var subscriptions = Set<AnyCancellable>()
    
    //    @Published var email: String = ""
    //    @Published var emailState: FieldState = .idle
    //    @Published var password: String = ""
    //    @Published var passwordState: FieldState = .idle
    
    func dismiss() {
        coordinator.dismissScreen()
    }
}



