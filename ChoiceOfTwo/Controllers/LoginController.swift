//
//  LoginController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Variables
    var vm = LoginVM()
    
    //MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Please sign in to continue")
    private let emailField = CustomTextField(textFieldType: .email)
    private let passwordField = CustomTextField(textFieldType: .password)
    private let signInButton = CustomButton(text: "Sign In", type: .medium)
    private let backButton = CustomBackButton()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainPurple
        setupUI()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 210),
            self.headerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -165),

            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 50),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 50),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            self.signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 50),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
//            self.backButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 40),

        ])
    }
}
