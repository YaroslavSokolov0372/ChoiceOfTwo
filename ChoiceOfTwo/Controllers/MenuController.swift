//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/02/2024.
//

import UIKit

class MenuController: UIViewController {
    
    
    //MARK: - Variable
    var vm: MenuVM!

    
    //MARK: - UI Components
    private let logoutButton: UIButton = {
        let button = UIButton()
        let im = UIImage(named: "Logout")!
            .resize(targetSize: CGSize(width: 27, height: 27))
            .withRenderingMode(.alwaysTemplate)
        button.tintColor = .mainPurple
        button.transform = CGAffineTransformMakeRotation(CGFloat(Double.pi / 1))
        button.setImage(im, for: .normal)
        return button
    }()
    private let startGameButton = CustomButton(
        text: "Start Game",
        type: .medium,
        backgroundColor: .mainPurple,
        textColor: .white)
    private let infoButton = CustomCircleButton(customImage: "Info", resized: CGSize(width: 60, height: 60))
    
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        friendsCollView.dataSource = self
        friendsCollView.delegate = self
        historyCollView.dataSource = self
        historyCollView.delegate = self
    }
    
    //MARK: Setup UI
    private func setupUI() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(startGameButton)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            self.logoutButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.logoutButton.heightAnchor.constraint(equalToConstant: 27),
            self.logoutButton.widthAnchor.constraint(equalToConstant: 27),
            self.logoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),

            
            self.startGameButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.startGameButton.heightAnchor.constraint(equalToConstant: 40),
            self.startGameButton.widthAnchor.constraint(equalToConstant: 110),
            self.startGameButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            
            self.infoButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.infoButton.heightAnchor.constraint(equalToConstant: 40),
            self.infoButton.widthAnchor.constraint(equalToConstant: 40),
            self.infoButton.trailingAnchor.constraint(equalTo: self.startGameButton.leadingAnchor, constant: -10),
            
            
            self.friendsHeaderLabel.topAnchor.constraint(equalTo: self.logoutButton.bottomAnchor, constant: 20),
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
    @objc private func logoutButtonTapped() {
        vm.signOut { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        vm.dismissHomeScreens()
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}


