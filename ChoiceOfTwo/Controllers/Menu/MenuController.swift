//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/02/2024.
//

import UIKit

class MenuController: UIViewController, FriendCellDelegate, AddFriendDelegate {
    
    
    
    //MARK: - Variable
    var vm: MenuVM!
    
    
    //MARK: - UI Components
    private let profileImageButton = CustomCircleButton(customImage: "Profile")
    private let friendsHeaderLabel = CustomSectionHeaderView(headerName: "Friends")
    public let friendsCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.showsHorizontalScrollIndicator = false
        //        collectionV.backgroundColor = .mainPurple
        collectionV.register(FriendCellView.self, forCellWithReuseIdentifier: "Cell")
        return collectionV
    }()
    private let friendsDevider = Devider(color: .mainPurple)
    private let historyHeaderLabel = CustomSectionHeaderView(headerName: "History")
    public let historyCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.register(HistoryCellView.self, forCellWithReuseIdentifier: "Cell")
        collectionV.showsVerticalScrollIndicator = false
        return collectionV
    }()
    private let scrollView: UIScrollView = {
      let scrollV = UIScrollView()
        return scrollV
    }()

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
                profileImageButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
//        profileImageButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        friendsCollView.dataSource = self
        friendsCollView.delegate = self
        historyCollView.dataSource = self
        historyCollView.delegate = self
        
        vm.onFriendsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.friendsCollView.reloadData()
            }
        }
    }
    
    //MARK: Setup UI
    private func setupUI() {
        
        view.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(friendsHeaderLabel)
        friendsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(friendsCollView)
        friendsCollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(friendsDevider)
        friendsDevider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(historyHeaderLabel)
        historyHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(historyCollView)
        historyCollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.profileImageButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.profileImageButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.profileImageButton.heightAnchor.constraint(equalToConstant: 50),
            self.profileImageButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.friendsHeaderLabel.topAnchor.constraint(equalTo: self.profileImageButton.bottomAnchor, constant: 10),
            self.friendsHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.friendsHeaderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            self.friendsCollView.topAnchor.constraint(equalTo: self.friendsHeaderLabel.bottomAnchor, constant: 10),
            self.friendsCollView.heightAnchor.constraint(equalToConstant: 95),
            self.friendsCollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.friendsCollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.friendsDevider.topAnchor.constraint(equalTo: friendsCollView.bottomAnchor, constant: 10),
            self.friendsDevider.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.93),
            self.friendsDevider.heightAnchor.constraint(equalToConstant: 1),
            self.friendsDevider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.historyHeaderLabel.topAnchor.constraint(equalTo: self.friendsCollView.bottomAnchor, constant: 20),
            self.historyHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.historyHeaderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            self.historyCollView.topAnchor.constraint(equalTo: historyHeaderLabel.bottomAnchor, constant: 10),
            self.historyCollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.historyCollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.historyCollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    //MARK: - Selectors
//    @objc private func logoutButtonTapped() {
//        vm.signOut { error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//        vm.dismissHomeScreens()
//    }
    
    @objc private func profileButtonTapped() {
        vm.profile()
    }
    
    func friendProfileTapped() {
//        print("Profile tapped")
        vm.profile()
    }
    
    func plusButtonTapped() {
        vm.searchFirends()
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}


