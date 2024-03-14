//
//  ProfileController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 18/02/2024.
//

import UIKit

class ProfileController: UIViewController {
    //MARK: - Varibales
    var vm: ProfileVM!

    
    //MARK: - UI Components
    private let backButton = CustomButton(text: "Back", type: .medium, strokeColor: .mainPurple)
    private var profileImage: UIImageView = {
        let im = UIImage(named: "Profile")?.withRenderingMode(.alwaysTemplate)
        let iv = UIImageView()
        iv.image = im
        iv.tintColor = .mainPurple
        return iv
    }()
    private let usernameTextField = CustomTextField(textFieldType: .username)
    private let usernameDescription: UILabel = {
      let label = UILabel()
        label.text = "Here you can change your username to be displayed"
        label.textColor = .secondaryLabel
        label.font = .nunitoFont(size: 14, type: .medium)
        return label
    }()
    private let emailLabel: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 12
        configuration.title = "zzz123123@gmail.com"
        configuration.background.backgroundColor = .mainLightGray
        configuration.baseForegroundColor = .mainDarkGray
        configuration.attributedTitle = AttributedString(configuration.title!, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.nunitoFont(size: 17, type: .medium)!]))
        button.configuration = configuration
        button.contentHorizontalAlignment = .left
        button.isUserInteractionEnabled = false
        return button
    }()
    private let emailDescription: UILabel = {
        let label = UILabel()
        label.text = "Current user email. Can be change by button below"
        label.textColor = .secondaryLabel
        label.font = .nunitoFont(size: 14, type: .medium)
        return label
    }()
    private let changeMailButton = CustomButton(text: "Change Email", type: .medium, textColor: .mainPurple, strokeColor: .mainPurple)
    private let logoutButton = CustomButton(text: "Log out", type: .medium, textColor: .mainRed, strokeColor: .mainRed)
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.isModalInPresentation = true
        setupUI()
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameDescription)
        usernameDescription.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailDescription)
        emailDescription.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(changeMailButton)
        changeMailButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            
            profileImage.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            
            usernameTextField.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 20),
            usernameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            
            usernameDescription.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 5),
            usernameDescription.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            usernameDescription.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor, constant: 10),
            usernameDescription.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor, constant: -10),
            
            emailLabel.topAnchor.constraint(equalTo: self.usernameDescription.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emailLabel.heightAnchor.constraint(equalToConstant: 50),
            emailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            
            emailDescription.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailDescription.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emailDescription.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor, constant: 10),
            emailDescription.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor, constant: -10),
            
            changeMailButton.topAnchor.constraint(equalTo: self.emailDescription.bottomAnchor, constant: 10),
            changeMailButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            changeMailButton.heightAnchor.constraint(equalToConstant: 50),
            changeMailButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            
            logoutButton.topAnchor.constraint(equalTo: self.changeMailButton.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
        ])
    }
    
    //MARK: - Selectors
    
    @objc private func logoutButtonTapped() {
        vm.signOut { error in
            if let error = error {
                print(error)
            }
        }
        
        vm.dismissHomeScreens()
    }
    
    @objc private func backButtonTapped() {
        vm.dismiss()
    }
    
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
