//
//  FriendCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit

protocol FriendCellDelegate {
    
    func friendProfileTapped(friend: User, cell: UICollectionViewCell)
}

protocol AddFriendDelegate {
    func plusButtonTapped()
}

class FriendCellView: UICollectionViewCell {
    
    //MARK: - Variables
    var friendsDelegate: FriendCellDelegate?
    var addFriendsDelegate: AddFriendDelegate?
    var friend: User!
    
    //MARK: UI Components
    private let profileImageButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.background.strokeColor = .mainPurple
        configuration.baseForegroundColor = .mainPurple
        configuration.background.cornerRadius = 30
        button.configuration = configuration
        button.clipsToBounds = true
        button.tintColor = .mainPurple
        return button
    }()
    
    
    private let name: UILabel = {
      let label = UILabel()
        label.text = "Yaroslav Sokolov"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font =  .nunitoFont(size: 12, type: .medium)
        label.textColor = .black
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        profileImageButton.addTarget(self, action: #selector(profilleImageTapped), for: .touchUpInside)
        profileImageButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.profileImageButton.heightAnchor.constraint(equalToConstant: 60),
            self.profileImageButton.widthAnchor.constraint(equalToConstant: 60),
            self.profileImageButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.profileImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.name.topAnchor.constraint(equalTo: self.profileImageButton.bottomAnchor, constant: 7),
            self.name.centerXAnchor.constraint(equalTo: self.profileImageButton.centerXAnchor),
            self.name.widthAnchor.constraint(equalToConstant: 95),
        ])
    }
    
    //MARK: - Selectors
    @objc private func profilleImageTapped() {
        friendsDelegate?.friendProfileTapped(friend: friend, cell: self)
    }
    
    @objc private func plusButtonTapped() {
        addFriendsDelegate?.plusButtonTapped()
    }
    
    //MARK: Configure
    public func configure(isFirst: Bool, with user: User? = nil) {
        if isFirst {
            let im = UIImage(named: "Plus")!.withRenderingMode(.alwaysTemplate)
            profileImageButton.setImage(im, for: .normal)
            name.text = "Add Friend"
        }
        if let user = user {
            let im = UIImage(named: "Profile")!.withRenderingMode(.alwaysTemplate)
            profileImageButton.setImage(im, for: .normal)
            friend = user
            name.text = user.username
        }
    }
    
    public func configureFirst() {
        
    }
}

