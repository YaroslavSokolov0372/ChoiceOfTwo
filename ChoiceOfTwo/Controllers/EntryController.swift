//
//  EntryController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import UIKit

class EntryController: UIViewController {
    
    
    //MARK: - Variables
    var vm: EntryVM!
    
    //MARK: - UI Components
    private let loginButton = CustomButton(text: "Login", type: .medium)
    
    private let createAccButton = CustomButton(text: "Create Account", type: .medium)
    
    private let bridge: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textColor = .white
        label.font = .nunitoFont(size: 18, type: .medium)
        return label
    }()
    
    private let choiceOfTwo: UILabel = {
        let label = UILabel()
        label.text = "CHOICE OF TWO"
        label.textColor = .white
        label.font = .nunitoFont(size: 30, type: .bold)
        return label
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainPurple
        setupUI()
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        createAccButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Setup Ui
    private func setupUI() {
        view.addSubview(choiceOfTwo)
        choiceOfTwo.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(createAccButton)
        createAccButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bridge)
        bridge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            choiceOfTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            choiceOfTwo.heightAnchor.constraint(equalToConstant: 50),
            choiceOfTwo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            
            createAccButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccButton.topAnchor.constraint(equalTo: choiceOfTwo.bottomAnchor, constant: 100),
            createAccButton.heightAnchor.constraint(equalToConstant: 50),
            createAccButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: createAccButton.bottomAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
            bridge.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bridge.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            bridge.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    //MARK: Selectors
    @objc private func loginButtonTapped(_ sender: UIButton) {
        vm.goToLogin()
    }
    
    @objc private func registerButtonTapped(_ sender: UIButton) {
        vm.goToRegister()
    }
    
    
}
