//
//  UserSearchCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import UIKit

protocol UserSearchCellDelegate {
    func sendFriendshipReq(to user: User)
}

class UserSearchCellView: UICollectionViewCell {
    
    //MARK: - Variables
    var user: User!
    var delegate: UserSearchCellDelegate?

    //MARK: - UI Components
    private var profileImage: UIImageView = {
      let im = UIImage(named: "Profile")
      let iv = UIImageView()
        iv.image = im
        return iv
    }()
    
    private var username: UILabel = {
      let label = UILabel()
        label.font = .nunitoFont(size: 17, type: .regular)
        label.textColor = .mainPurple
        return label
    }()
    
    private let sendRequestButton = CustomButton(text: "Send Request", type: .small, strokeColor: .mainPurple)
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        sendRequestButton.addTarget(self, action: #selector(sendRequestTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        self.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(username)
        username.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(sendRequestButton)
        sendRequestButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            username.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            username.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            username.heightAnchor.constraint(equalToConstant: 20),
            
            sendRequestButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            sendRequestButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            sendRequestButton.widthAnchor.constraint(equalToConstant: 120),
            sendRequestButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    
    //MARK: - Selectors
    @objc private func sendRequestTapped() {
        delegate?.sendFriendshipReq(to: self.user)
    }
    
    public func configure(with user: User) {
        self.user = user
        self.username.text = user.username
    }
}
