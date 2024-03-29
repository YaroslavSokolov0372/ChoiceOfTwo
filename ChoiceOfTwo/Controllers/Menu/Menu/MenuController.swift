//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/02/2024.
//

import UIKit

class MenuController: UIViewController, FriendCellDelegate, AddFriendDelegate, InteractFriendDelegate, AnimatedMessageWithButtonsViewDelegate, HistoryCellDelegate {

    //MARK: - Variable
    var vm: MenuVM!
    
    //MARK: - UI Components
    let profileImageButton = CustomCircleButton(customImage: "Profile")
    let friendsHeaderLabel = CustomSectionHeaderView(headerName: "Friends")
    let friendsCollView: UICollectionView = {
        //        let layout = UICollectionViewFlowLayout()
        let layout = MyCollectionFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.showsHorizontalScrollIndicator = false
        //        collectionV.backgroundColor = .mainPurple
        collectionV.register(FriendCellView.self, forCellWithReuseIdentifier: "Cell")
        return collectionV
    }()
    let friendsDevider = Devider(color: .mainPurple)
    let historyHeaderLabel = CustomSectionHeaderView(headerName: "History")
    let historyCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.register(HistoryCellView.self, forCellWithReuseIdentifier: "Cell")
        collectionV.showsVerticalScrollIndicator = false
        return collectionV
    }()
    let scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        return scrollV
    }()
    lazy var friendInteractView = InteractFriendView()
    lazy var animatedMessageLabel = CustomAnimatedMessageLabel(frame: CGRect(
        x: (view.frame.width * 0.07),
        y: view.frame.maxY,
        width: (view.frame.width * 0.85),
        height: 55
    ))
    lazy var animatedGameInvView = CustomAnimatedMessageWithButtons(frame: CGRect(
        x: view.frame.minX - 350,
        y: 50,
        width: (view.frame.width * 0.85),
        height: 55
    ))
    lazy var animatedDeleteView = CustomAnimatedMessageWithButtons(frame: CGRect(
        x: view.frame.minX - 350,
        //        y: profileImageButton.frame.minY,
        y: 60,
        width: (view.frame.width * 0.85),
        height: 55
    ))
    var isFriendInteractVisible = false
    
    
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
        friendInteractView.delegate = self
        animatedDeleteView.delegate = self
        animatedGameInvView.delegate = self
        
        vm.onFriendsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.friendsCollView.reloadData()
            }
        }
        vm.onMatchesUpadated = {
            DispatchQueue.main.async { [weak self] in
                self?.historyCollView.reloadData()
            }
        }
        
        vm.onSendInvUpdated = {
            self.animatedMessageLabel.configure(message: "Invite sent!", strokeColor: .mainPurple, customFont: .nunitoFont(size: 18, type: .medium))
            self.animatedMessageLabel.playAnimation()
        }
        vm.onSendInvError = {
            self.animatedMessageLabel.configure(message: "Failed to send invite", strokeColor: .mainRed, customFont: .nunitoFont(size: 18, type: .medium))
            self.animatedMessageLabel.playAnimation()
        }
        vm.onGameInvListenerChange = { users in
            if !users.isEmpty {
                self.animatedGameInvView.playAnimation(users: users, type: .invite)
            }
        }
        vm.onDeletingFriendError = {
            self.animatedMessageLabel.configure(message: "Failed to delete friend", strokeColor: .mainRed, customFont: .nunitoFont(size: 18, type: .medium))
            self.animatedMessageLabel.playAnimation()
            self.animatedDeleteView.hideAnimation.startAnimation()
        }
        vm.onDeletingFriendSuccess = { user in
            
            let index = self.vm.friends.firstIndex(where: { $0.uid == user.uid })
            let indexPath = IndexPath(row: index! + 1, section: 0)
            
            let cell = self.friendsCollView.cellForItem(at: indexPath)
            self.friendProfileTapped(friend: user, cell: cell!)
            self.friendsCollView.performBatchUpdates {
                self.vm.removeFriend(at: index!)
                self.friendsCollView.deleteItems(at: [indexPath])
            } completion: { (finished: Bool) in
                self.animatedDeleteView.hideAnimation.startAnimation()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(animatedMessageLabel)
        view.addSubview(animatedGameInvView)
        view.addSubview(animatedDeleteView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await vm.getHistory()
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //        vm.removeListeners()
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
        
        view.addSubview(friendInteractView)
        
        //        view.addSubview(animatedMessageLabel)
        
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
    @objc private func profileButtonTapped() {
        vm.profile()
    }
    
    //MARK: - Delegate
    func matchTapped(match: Match) {
        vm.matchDetail(match: match)
    }
    
    func friendProfileTapped(friend: User, cell: UICollectionViewCell) {
        friendInteractView.configure(with: friend) { isTheSame, isOpened in
            if !isTheSame {
                self.friendInteractView.hide(cell: cell) {
                    self.friendInteractView.showUnder(cell: cell)
                }
                return true
            } else {
                if isOpened {
                    self.friendInteractView.hide(cell: cell) {}
                    return false
                } else {
                    self.friendInteractView.showUnder(cell: cell)
                    return true
                }
            }
        }
    }
    
    func plusButtonTapped() {
        vm.searchFirends()
    }
    
    func inviteFriendTapped(_ friend: User) {
        vm.sendInv(to: friend)
    }
    
    func deleteFriendTapped(_ friend: User) {
        animatedDeleteView.playAnimation(users: [friend], type: .delete)
    }
    
    func declineInvite(of friend: User) {
        self.animatedGameInvView.hideAnimation.startAnimation()
    }
    
    func accpetInvite(of friend: User) {
        vm.acceptGameInv(of: friend)
        self.animatedGameInvView.hideAnimation.startAnimation()
    }
    
    func deleteFriend(_ friend: User) {
        vm.deleteFriend(friend: friend)
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}


