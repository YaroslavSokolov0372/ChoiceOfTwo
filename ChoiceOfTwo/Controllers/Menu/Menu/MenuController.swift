//
//  MenuController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/02/2024.
//

import UIKit
import SkeletonView

class MenuController: UIViewController, FriendCellDelegate, AddFriendDelegate, InteractFriendDelegate, AnimatedMessageWithButtonsViewDelegate, HistoryCellDelegate {
    
    //MARK: - Variable
    var vm: MenuVM!
    var isFriendInteractVisible = false
    
    //MARK: - UI Components
    let circleImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.backgroundColor = .mainLightGray
        iv.alpha = 1.0
        iv.isUserInteractionEnabled = true
        return iv
    }()
    let friendsHeaderLabel = CustomSectionHeaderView(headerName: "Friends")
    let friendsCollView: UICollectionView = {
        let layout = MyCollectionFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.showsHorizontalScrollIndicator = false
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
        y: 60,
        width: (view.frame.width * 0.85),
        height: 55
    ))

    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        animatedGameInvView.alpha = 0.0
        animatedDeleteView.alpha = 0.0
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        self.circleImage.addGestureRecognizer(gesture)
        
        
        circleImage.isSkeletonable = true
        friendsCollView.dataSource = self
        friendsCollView.delegate = self
        friendsCollView.isSkeletonable = true
        historyCollView.dataSource = self
        historyCollView.delegate = self
        historyCollView.isSkeletonable = true
        friendInteractView.delegate = self
        animatedDeleteView.delegate = self
        animatedGameInvView.delegate = self
        
        vm.onProfileImageChanges = { str in
            let image = UIImage(data: str)
            self.circleImage.image = image
        }
        vm.onFriendsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.friendsCollView.reloadData()
            }
        }
        
        vm.onFinishingFetching = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.historyCollView.reloadData()
                self.historyCollView.hideSkeleton()
                self.friendsCollView.reloadData()
                self.friendsCollView.hideSkeleton()
                self.circleImage.hideSkeleton()
            }
        }
        
        vm.onMatchesUpadated = {
            DispatchQueue.main.async { [weak self] in
                self?.historyCollView.reloadSections(IndexSet(integer: 0))
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            
        if !vm.isFetchedOnce {
            self.historyCollView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .mainLightGray, secondaryColor: .mainLightGray), transition: .crossDissolve(0.25))
            self.friendsCollView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .mainLightGray, secondaryColor: .mainLightGray), transition: .crossDissolve(0.25))
            self.circleImage.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .mainLightGray, secondaryColor: .mainLightGray), transition: .crossDissolve(0.25))
        }
        
        Task {
            await vm.getHistory()
        }
    }
    
    //MARK: Setup UI
    private func setupUI() {
        view.addSubview(circleImage)
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        NSLayoutConstraint.activate([
            
            self.circleImage.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.circleImage.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.circleImage.heightAnchor.constraint(equalToConstant: 50),
            self.circleImage.widthAnchor.constraint(equalToConstant: 50),
            
            self.friendsHeaderLabel.topAnchor.constraint(equalTo: self.circleImage.bottomAnchor, constant: 10),
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
        vm.profile(image: circleImage.image!)
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
        
        let index = vm.friends.firstIndex(where: { $0.uid == friend.uid })!
        let indexPath = IndexPath(item: index + 1, section: 0)
        if let customCell = friendsCollView.cellForItem(at: indexPath) as? FriendCellView {
            friendInteractView.configure(with: friend) { isTheSame, isOpened in
                if !isTheSame {
                    self.friendInteractView.hide(cell: customCell) {
                        self.friendInteractView.showUnder(cell: customCell)
                    }
                    return true
                } else {
                    if isOpened {
                        self.friendInteractView.hide(cell: customCell) {}
                        return false
                    } else {
                        self.friendInteractView.showUnder(cell: customCell)
                        return true
                    }
                }
            }
        }
    }
    
    func deleteFriendTapped(_ friend: User) {
        animatedDeleteView.playAnimation(users: [friend], type: .delete)
        let index = vm.friends.firstIndex(where: { $0.uid == friend.uid })!
        let indexPath = IndexPath(item: index + 1, section: 0)
        if let customCell = friendsCollView.cellForItem(at: indexPath) as? FriendCellView {
            friendInteractView.configure(with: friend) { isTheSame, isOpened in
                if !isTheSame {
                    self.friendInteractView.hide(cell: customCell) {
                        self.friendInteractView.showUnder(cell: customCell)
                    }
                    return true
                } else {
                    if isOpened {
                        self.friendInteractView.hide(cell: customCell) {}
                        return false
                    } else {
                        self.friendInteractView.showUnder(cell: customCell)
                        return true
                    }
                }
            }
        }
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


