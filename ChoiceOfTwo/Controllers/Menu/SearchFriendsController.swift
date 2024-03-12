//
//  SearchFriendsController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import UIKit
import FirebaseAuth

class SearchFriendsController: UIViewController, UserSearchCellDelegate, RecievedIntCellDelegate {
    
    //MARK: - Variables
    var vm: SearchFriendsVM!
    var currentPage = 1 {
        didSet {
            if oldValue != currentPage {
                vm.subscriptions.removeAll()
                if currentPage == 1 {
                    vm.fetchUsersSentFriendship()
//                    listenForSearchTextChanges()
//                    requestOnSearchNewUserBinding()
                } else if currentPage == 2 {
                    vm.removeSearchUsers()
//                    listenForSearchTextChanges()
//                    requestOnSearchInvUserBinding()
                }
            }
        }
    }
    var activeTabIndicatorConstraints: [NSLayoutConstraint] = [] {
    willSet {
        NSLayoutConstraint.deactivate(activeTabIndicatorConstraints)
    }
    didSet {
        NSLayoutConstraint.activate(activeTabIndicatorConstraints)
    }
}
    
    
    //MARK: - UI Components
    private let backButton = CustomButton(text: "Back", type: .medium, strokeColor: .mainPurple)
    private (set) var usernameField = CustomTextField(textFieldType: .username)
    private (set) var tabIndicator = Devider(color: .mainPurple)
    private let scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.isPagingEnabled = true
        scrollV.showsVerticalScrollIndicator = false
        scrollV.keyboardDismissMode = .onDrag
        return scrollV
    }()
    private (set) var usersSearchCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.register(UserSearchCellView.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    private (set) var recievedInvUsersCollView: UICollectionView = {
      let layout = MyCollectionFlowLayout()
//        let layout = MyCollectionFlowLayout()
        layout.scrollDirection = .vertical
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.showsVerticalScrollIndicator = false
        collectionV.register(RecievedCellView.self, forCellWithReuseIdentifier: "Cell")
        return collectionV
    }()
    private let usersSearchTabButton = CustomButton(text: "SEARCH FRIENDS", type: .medium, textColor: .mainPurple)
    private let recievedInvTabButton = CustomButton(text: "RECIEVED INVITES", type: .medium, textColor: .mainPurple)
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.isModalInPresentation = true

        vm.fetchWhomSentFriendship()
        vm.fetchUsersSentFriendship()
        vm.onUsersWhoSentFriendshipAction = { [weak self] in
            DispatchQueue.main.async {
                self?.recievedInvUsersCollView.reloadData()
            }
        }
        vm.onFetchWhomSentFriendshipAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.usersSearchCollView.reloadData()
            }
        }
        vm.onSearchChange = { [weak self] in
            DispatchQueue.main.async {
                self?.usersSearchCollView.reloadData()
            }
        }
        
        
        setupUI()
        listenForSearchTextChanges()
        requestOnSearchNewUserBinding()
        
        
        recievedInvTabButton.addTarget(self, action: #selector(recievedInvButtonTapped), for: .touchUpInside)
        usersSearchTabButton.addTarget(self, action: #selector(userSearchButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        usersSearchCollView.dataSource = self
        usersSearchCollView.delegate = self
        recievedInvUsersCollView.delegate = self
        recievedInvUsersCollView.dataSource = self
        usernameField.delegate = self
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        print("DEBUG: Scroll view subviews before set up", scrollView.subviews.count)
        if scrollView.subviews.count == 1 {
            scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.scrollView.frame.height)
            configureCollViews()
        }
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {

        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(searchHeader)
//        searchHeader.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tabIndicator)
        tabIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usersSearchTabButton)
        usersSearchTabButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(recievedInvTabButton)
        recievedInvTabButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            
//            searchHeader.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 10),
//            searchHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
//            searchHeader.heightAnchor.constraint(equalToConstant: 30),
//            usernameField.topAnchor.constraint(equalTo: self.searchHeader.bottomAnchor, constant: 12),
            usernameField.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 20),
            usernameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            
            tabIndicator.topAnchor.constraint(equalTo: self.usernameField.bottomAnchor, constant: 10),
            tabIndicator.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            tabIndicator.heightAnchor.constraint(equalToConstant: 2),
//            tabIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            tabIndicator.leadingAnchor.constraint(equalTo: usersSearchTabButton.leadingAnchor),
            
            usersSearchTabButton.topAnchor.constraint(equalTo: self.tabIndicator.topAnchor, constant: 7),
            usersSearchTabButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            usersSearchTabButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            usersSearchTabButton.heightAnchor.constraint(equalToConstant: 30),
            
            recievedInvTabButton.topAnchor.constraint(equalTo: self.tabIndicator.topAnchor, constant: 7),
            recievedInvTabButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            recievedInvTabButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            recievedInvTabButton.heightAnchor.constraint(equalToConstant: 30),
            
            scrollView.topAnchor.constraint(equalTo: self.usersSearchTabButton.bottomAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        setupActiveConstrainsts()
    }
    
    private func setupActiveConstrainsts() {
        activeTabIndicatorConstraints = [
            tabIndicator.leadingAnchor.constraint(equalTo: usersSearchTabButton.leadingAnchor),
        ]
    }
    
    
    private func configureCollViews() {
        usersSearchCollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
        scrollView.addSubview(usersSearchCollView)
        recievedInvUsersCollView.frame = CGRect(x: self.view.frame.width * 1, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
        scrollView.addSubview(recievedInvUsersCollView)
//        sentInvToUsersCollView.frame = CGRect(x: self.view.frame.width * 2, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
//        scrollView.addSubview(sentInvToUsersCollView)
    }
    
    
    //MARK: - Binding
    func listenForSearchTextChanges() {
        self.usernameField.textPublisher()
            .assign(to: \.searchText, on: vm)
            .store(in: &vm.subscriptions)
    }
    
    func requestOnSearchNewUserBinding() {
        self.vm.$searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] userSearch in
                self?.vm.searchUsersWith(userSearch)
            }.store(in: &vm.subscriptions)
    }
    
    
    func requestOnSearchInvUserBinding() {
        self.vm.$searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] userSearch in
                if userSearch.isEmpty {
                    self?.vm.fetchUsersSentFriendship()
                } else {
                    self?.vm.searchInRecievedInv(with: userSearch)
                }
            }.store(in: &vm.subscriptions)
    }
    
    //MARK: - Selectors
    @objc private func backButtonTapped() {
        vm.dismiss()
        
    }
    
    @objc private func userSearchButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.activeTabIndicatorConstraints = [
                self.tabIndicator.leadingAnchor.constraint(equalTo: self.usersSearchTabButton.leadingAnchor),
            ]
            self.scrollView.contentOffset.x = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func recievedInvButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.activeTabIndicatorConstraints = [
                self.tabIndicator.leadingAnchor.constraint(equalTo: self.view.centerXAnchor),
                
            ]
            self.scrollView.contentOffset.x = self.view.frame.width
            self.view.layoutIfNeeded()
        })
    }
    
    
    //MARK: - Delegate
    func sendFriendshipReq(to user: User, completion: @escaping (Bool) -> Void) {
        vm.sendFriendShipReq(to: user) { success in
            completion(success)
        }
    }
    
    func declineWhomSentReq(from user: User, completion: @escaping (Bool) -> Void) {
        vm.declineWhomSentReq(from: user) { success in
            completion(success)
        }
    }
    
    func acceptFriendShipReq(from user: User, index: Int) {
        print("DEBUG: Tapped accept")
        
        vm.acceptFriendship(user: user) { success in
            let indexPath = IndexPath(row: index, section: 0)
            self.recievedInvUsersCollView.performBatchUpdates {
                self.vm.removeSentInvUsers(at: index)
                self.recievedInvUsersCollView.deleteItems(at: [indexPath])
            } completion: { (finished: Bool) in
                self.recievedInvUsersCollView.reloadItems(at: self.recievedInvUsersCollView.indexPathsForVisibleItems)
            }
        }
    }
    
        func declineFriendShipReq(from user: User, index: Int) {
            print("DEBUG: Tapped decline")
            vm.declineFriendship(user: user) { success in
                let indexPath = IndexPath(row: index, section: 0)
                self.recievedInvUsersCollView.performBatchUpdates {
                    self.vm.removeSentInvUsers(at: index)
                    self.recievedInvUsersCollView.deleteItems(at: [indexPath])
                } completion: { (finished: Bool) in
                    self.recievedInvUsersCollView.reloadItems(at: self.recievedInvUsersCollView.indexPathsForVisibleItems)
                }
            }
        }
        
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
    
}
