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
    lazy var messageLabel = CustomAnimatedMessageLabel(frame: CGRect(
        x: (view.frame.width * 0.07),
//        y: (view.frame.maxY - 200),
        y: view.frame.maxY,
        width: (view.frame.width * 0.85),
        height: 65))
    let scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.isScrollEnabled = false
        scrollV.contentInsetAdjustmentBehavior = .never
        scrollV.backgroundColor = .white
        return scrollV
    }()
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
     let headerView = AuthHeaderView(title: "Sign In", subTitle: "Please sign in to continue")
     let emailField = CustomTextField(textFieldType: .email, strokeColor: .mainPurple, backgroundColor: .white)
     let passwordField = CustomTextField(textFieldType: .password, strokeColor: .mainPurple, backgroundColor: .white)
     let signInButton = CustomButton(text: "Sign In", type: .medium, strokeColor: .mainPurple)
     let backButton = CustomCircleButton(rotate: 1, stroke: true)
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindEmail()
        bindPassword()
        backButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        registerKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        contentView.addSubview(messageLabel)
        messageLabel.configure(message: "Error", strokeColor: .mainRed)
    }

    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            
            self.scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            self.contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
//            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.topAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
//            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.backButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            
            self.headerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 210),
            self.headerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -165),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            self.signInButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
    }
    
    
    //MARK: - Bind
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
    
    //MARK: Selectors
    @objc private func dismissButtonTapped() {
        vm.dismiss()
    }
    
    @objc private func signInButtonTapped() {
        vm.signIn { error in
            if let error = error {
                self.messageLabel.configure(message: error.localizedDescription, strokeColor: .mainRed)
                self.messageLabel.playAnimation()
            }
        }
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
