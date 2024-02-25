//
//  UserSearchCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import UIKit

protocol UserSearchCellDelegate {
    func sendFriendshipReq(to user: User)
    
    func acceptFriendShipReq(from user: User)
    
    func declineFriendShipReq(from user: User)
}

class UserSearchCellView: UICollectionViewCell {
    
    enum CellType {
        case recieved
        case search
    }
    
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
    
    //MARK: - Search Type
    private let sendRequestButton = CustomButton(text: "Send Request", type: .small, strokeColor: .mainPurple)
    //MARK: - Recieved Type
    private let declineButton = CustomCircleButton(customImage: "Plus", rotate: 4, resized: CGSize(width: 25, height: 25), imageColor: .mainPurple, stroke: true, cornerRadius: 23)
    private let acceptButton = CustomCircleButton(customImage: "CheckMark", resized: CGSize(width: 25, height: 25), imageColor: .mainPurple, stroke: true, cornerRadius: 23)
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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

        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            username.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            username.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            username.heightAnchor.constraint(equalToConstant: 20),
            

        ])
    }
    
    private func setupButtonsForReceived() {
        
        self.addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(acceptButton)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            declineButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            declineButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            declineButton.widthAnchor.constraint(equalToConstant: 45),
            declineButton.heightAnchor.constraint(equalToConstant: 45),
            
            acceptButton.trailingAnchor.constraint(equalTo: declineButton.leadingAnchor, constant: -15),
            acceptButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 45),
            acceptButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    private func setupButtonForSearch() {
        
        self.addSubview(sendRequestButton)
        sendRequestButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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
    
    @objc private func declineButtonTapped() {
        delegate?.declineFriendShipReq(from: self.user)
    }
    
    @objc private func acceptButtonTapped() {
        delegate?.acceptFriendShipReq(from: self.user)
    }
    
    //MARK: - Configure
    public func configure(with user: User, asType: CellType) {
        switch asType {
        case .recieved:
            setupButtonsForReceived()
            declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
            acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        case .search:
            setupButtonForSearch()
            sendRequestButton.addTarget(self, action: #selector(sendRequestTapped), for: .touchUpInside)
        }
        self.user = user
        self.username.text = user.username
    }
}
