//
//  RegisterController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import UIKit

class RegisterController: UIViewController {
    
    
    
    //MARK: - Variabels
    var vm = RegisterVM()
    private let authService = AuthService()
    
    
    //MARK: - UI Components
    private let usernameField = CustomTextField(textFieldType: .username)
    private let userEmail = CustomTextField(textFieldType: .email)
    private let userPassword = CustomTextField(textFieldType: .password)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainPurple
        setupUI()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userEmail)
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPassword)
        userPassword.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
        ])
    }
}
