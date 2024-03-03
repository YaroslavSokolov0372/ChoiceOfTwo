//
//  EntryController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import UIKit
import GoogleSignIn

class EntryController: UIViewController {
    
    
    //MARK: - Variables
    var vm: EntryVM!
    
    //MARK: - UI Components
    private let imageLogoView: UIImageView = {
      let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "LogoImage")
//        ?.resize(targetSize: CGSize(width: 160, height: 160))
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        return iv
    }()
    private let loginButton = CustomButton(text: "Login", type: .medium, strokeColor: .mainPurple)
    private let createAccButton = CustomButton(text: "Create Account", type: .medium, strokeColor: .mainPurple)
    private let bridgeLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
//        label.textColor = .white
        label.textColor = .mainPurple
        label.font = .nunitoFont(size: 18, type: .medium)
        return label
    }()
    private let googleSignButton = CustomImageAuthButton(image: "Google", title: "Sign Up with Google", strokeColor: .mainPurple)
    private let appleSignButton = CustomImageAuthButton(image: "Apple", title: "Sign Up with Google", strokeColor: .mainPurple)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .mainPurple
        view.backgroundColor = .white
        setupUI()
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        createAccButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        googleSignButton.addTarget(self, action: #selector(registerWithGoogle), for: .touchUpInside)
    }
    
    //MARK: - Setup Ui
    private func setupUI() {
        
        view.addSubview(imageLogoView)
        imageLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(createAccButton)
        createAccButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bridgeLabel)
        bridgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(googleSignButton)
        googleSignButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(appleSignButton)
        appleSignButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            imageLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageLogoView.widthAnchor.constraint(equalToConstant: 100),
//            imageLogoView.heightAnchor.constraint(equalToConstant: 100),
            imageLogoView.widthAnchor.constraint(equalToConstant: 140),
            imageLogoView.heightAnchor.constraint(equalToConstant: 140),
            imageLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            
            createAccButton.topAnchor.constraint(equalTo: imageLogoView.bottomAnchor, constant: 50),
            createAccButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            createAccButton.heightAnchor.constraint(equalToConstant: 50),
            createAccButton.heightAnchor.constraint(equalToConstant: 55),
            createAccButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: createAccButton.bottomAnchor, constant: 20),
//            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 55),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            bridgeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bridgeLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            bridgeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            googleSignButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignButton.topAnchor.constraint(equalTo: bridgeLabel.bottomAnchor, constant: 25),
//            googleSignButton.heightAnchor.constraint(equalToConstant: 50),
            googleSignButton.heightAnchor.constraint(equalToConstant: 55),
            googleSignButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            appleSignButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleSignButton.topAnchor.constraint(equalTo: googleSignButton.bottomAnchor, constant: 20),
//            appleSignButton.heightAnchor.constraint(equalToConstant: 50),
            appleSignButton.heightAnchor.constraint(equalToConstant: 55),
            appleSignButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    //MARK: Selectors
    @objc private func loginButtonTapped(_ sender: UIButton) {
        vm.goToLogin()
    }
    
    @objc private func registerButtonTapped(_ sender: UIButton) {
        vm.goToRegister()
    }
    
    @objc private func registerWithGoogle() {
        vm.signInWithGoogle(viewController: self) { error in
            print(error.localizedDescription)
        }
//        AuthService.shared.registerWithGoogle(viewController: self) { bool, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
    }
       
}
