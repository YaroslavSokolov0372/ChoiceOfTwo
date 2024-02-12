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
    
    private let headerView = AuthHeaderView(title: "Register Now", subTitle: "Register to continue")
    private let usernameField = CustomTextField(textFieldType: .username)
    private let emailField = CustomTextField(textFieldType: .email)
    private let passwordField = CustomTextField(textFieldType: .password)
    private let signUpButton = CustomButton(text: "Register", type: .medium)
    private let backButton = CustomBackButton()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainPurple
        setupUI()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        backButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        
        vm.username.startValidation()
        vm.username.$textState
            .sink { [weak self] state in
                self?.usernameField.validationStateChanged(state: state)
            }.store(in: &vm.subscriptions)
        
        vm.email.startValidation()
        vm.email.$textState
            .sink { [weak self] state in
                self?.emailField.validationStateChanged(state: state)
            }.store(in: &vm.subscriptions)
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 210),
            self.headerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -165),
            
            self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.usernameField.heightAnchor.constraint(equalToConstant: 50),
            self.usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 50),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 50),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            self.signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 50),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    //MARK: - Binding
    private func bindEmail() {
        emailField
            .textPublisher()
            .assign(to: \.email.text, on: vm)
            .store(in: &vm.subscriptions)
    }
    
    private func bindPassword() {
        passwordField
            .textPublisher()
            .assign(to: \.password.text, on: vm)
            .store(in: &vm.subscriptions)
    }
    
    private func bindUsername() {
        usernameField
            .textPublisher()
            .assign(to: \.username.text, on: vm)
            .store(in: &vm.subscriptions)
    }
    
    
    //MARK: Selectors
    @objc private func dismissButtonTapped() {
        vm.dismiss()
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
