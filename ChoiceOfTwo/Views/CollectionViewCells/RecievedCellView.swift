//
//  RecievedCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/03/2024.
//

import UIKit

protocol RecievedIntCellDelegate {
    
    func acceptFriendShipReq(from user: User, index: Int)
    
    func declineFriendShipReq(from user: User, index: Int)
}

class RecievedCellView: UICollectionViewCell {
    
    
    //MARK: - Variables
    var user: User!
    var delegate: RecievedIntCellDelegate?
    var index: Int!
    
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
    
    private let declineButton = CustomCircleButton(customImage: "Plus", rotate: 4, resized: CGSize(width: 25, height: 25), imageColor: .mainPurple, stroke: true, cornerRadius: 23)
    private let acceptButton = CustomCircleButton(customImage: "CheckMark", resized: CGSize(width: 25, height: 25), imageColor: .mainPurple, stroke: true, cornerRadius: 23)
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(username)
        username.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(acceptButton)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            username.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            username.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            username.heightAnchor.constraint(equalToConstant: 20),
            
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
    
    //MARK: - Selectors
    @objc private func declineButtonTapped() {
        delegate?.declineFriendShipReq(from: self.user, index: self.index)
        print("I am here")
    }
    
    @objc private func acceptButtonTapped() {
        print("I am there")
        delegate?.acceptFriendShipReq(from: self.user, index: self.index)
    }
    
    //MARK: - Configure
    public func configure(with user: User, index: Int) {
        self.index = index
        self.user = user
        self.username.text = user.username
    }
}
