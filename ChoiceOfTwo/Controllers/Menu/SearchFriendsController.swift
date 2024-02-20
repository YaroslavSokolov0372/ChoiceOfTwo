//
//  SearchFriendsController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import UIKit

class SearchFriendsController: UIViewController {
    
    //MARK: - Variables
    var vm: SearchFriendsVM!
    
    //MARK: - UI Components
    private let backButton = CustomButton(text: "Back", type: .medium)
    private let searchHeader = CustomSectionHeaderView(headerName: "Search Friends")
    private let usernameField = CustomTextField(textFieldType: .username)
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mainGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setupUI()
        self.isModalInPresentation = true
    }
         
         
    //MARK: - SetupUI
    private func setupUI() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchHeader)
        searchHeader.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            
            searchHeader.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 10),
            searchHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            searchHeader.heightAnchor.constraint(equalToConstant: 30),
            
            usernameField.topAnchor.constraint(equalTo: searchHeader.bottomAnchor, constant: 12),
            usernameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
        ])
    }
    
    //MARK: - Selectors
    @objc private func backButtonTapped() {
        vm.dismiss()
//        self.dismiss(animated: true)
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }

}
