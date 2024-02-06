//
//  LoginController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Variables
    
    
    //MARK: - UI Components
    private let emailField = CustomTextField(textFieldType: .email)
    
    private let passwordField = CustomTextField(textFieldType: .password)
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainPurple
        setupUI()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
    }
}
