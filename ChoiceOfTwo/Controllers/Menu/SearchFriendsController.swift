//
//  SearchFriendsController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import UIKit
import FirebaseAuth

class SearchFriendsController: UIViewController, UserSearchCellDelegate {
    
    
    
    //MARK: - Variables
    var vm: SearchFriendsVM!
    
    //MARK: - UI Components
    private let backButton = CustomButton(text: "Back", type: .medium, strokeColor: .mainPurple)
    private let searchHeader = CustomSectionHeaderView(headerName: "Search Friends")
    private let usernameField = CustomTextField(textFieldType: .username)
    private let searchDevider = Devider(color: .mainPurple)
    private let usersCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.register(UserSearchCellView.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        vm.onSearchChange = { [weak self] in
            DispatchQueue.main.async {
                self?.usersCollView.reloadData()
            }
        }
        
        setupUI()
        listenForSearchTextChanges()
        requestOnSearchBinding()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        usersCollView.dataSource = self
        usersCollView.delegate = self
        self.isModalInPresentation = true
        usernameField.delegate = self
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchHeader)
        searchHeader.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchDevider)
        searchDevider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usersCollView)
        usersCollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            
            searchHeader.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 10),
            searchHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            searchHeader.heightAnchor.constraint(equalToConstant: 30),
            
            usernameField.topAnchor.constraint(equalTo: self.searchHeader.bottomAnchor, constant: 12),
            usernameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            
            searchDevider.topAnchor.constraint(equalTo: self.usernameField.bottomAnchor, constant: 10),
            searchDevider.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.93),
            searchDevider.heightAnchor.constraint(equalToConstant: 1),
            searchDevider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            usersCollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            usersCollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            usersCollView.topAnchor.constraint(equalTo: self.searchDevider.bottomAnchor, constant: 15),
            usersCollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    
    //MARK: - Binding
    func listenForSearchTextChanges() {
        self.usernameField.textPublisher()
            .assign(to: \.searchText, on: vm)
            .store(in: &vm.subscriptions)
    }
    
    func requestOnSearchBinding() {
        self.vm.$searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { userSearch in
                self.vm.searchUsersWith(userSearch)
            }.store(in: &vm.subscriptions)
    }
    
    
    
    //MARK: - Selectors
    @objc private func backButtonTapped() {
        vm.dismiss()
        //        self.dismiss(animated: true)
    }
    
    
    //MARK: - Delegate
    func sendFriendshipReq(to user: User) {
        vm.sendFriendShipReq(to: user)
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
