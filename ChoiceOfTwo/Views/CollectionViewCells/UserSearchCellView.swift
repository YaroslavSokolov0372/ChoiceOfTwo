//
//  UserSearchCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import UIKit

protocol UserSearchCellDelegate {
    func sendFriendshipReq(to user: User, completion: @escaping (Bool) -> Void)
    
//    func acceptFriendShipReq(from user: User)
    
    func declineWhomSentReq(from user: User, completion: @escaping (Bool) -> Void)
}

class UserSearchCellView: UICollectionViewCell {
    //MARK: - Variables
    var user: User!
    var delegate: UserSearchCellDelegate?
    var alrdSentInv: Bool?
    
    var activeButtonsConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeButtonsConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeButtonsConstraints)
        }
    }

    //MARK: - UI Components
//    private var profileImage: UIImageView = {
//      let im = UIImage(named: "Profile")
//      let iv = UIImageView()
//        iv.image = im
//        return iv
//    }()
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
    private var username: UILabel = {
      let label = UILabel()
        label.font = .nunitoFont(size: 17, type: .regular)
        label.textColor = .mainPurple
        return label
    }()
    
    private let sendRequestButton = CustomButton(text: "Send Request", type: .small, strokeColor: .mainPurple)
    private let declineButton = CustomCircleButton(customImage: "Plus", rotate: 4, resized: CGSize(width: 25, height: 25), imageColor: .mainPurple, stroke: true, cornerRadius: 23)
    
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
//        self.addSubview(profileImage)
//        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(circleImage)
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(username)
        username.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            profileImage.widthAnchor.constraint(equalToConstant: 50),
//            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            circleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            circleImage.widthAnchor.constraint(equalToConstant: 50),
            circleImage.heightAnchor.constraint(equalToConstant: 50),
            
            username.leadingAnchor.constraint(equalTo: circleImage.trailingAnchor, constant: 10),
            username.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor),
            username.heightAnchor.constraint(equalToConstant: 20),
            

        ])
    }
    
    private func setupButtonWhomSent() {
        
        self.addSubview(sendRequestButton)
        sendRequestButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            declineButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
//            declineButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            declineButton.widthAnchor.constraint(equalToConstant: 45),
            declineButton.heightAnchor.constraint(equalToConstant: 45),
            
//            sendRequestButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
//            sendRequestButton.leadingAnchor.constraint(equalTo: declineButton.trailingAnchor, constant: 40),
//            sendRequestButton.centerYAnchor.constraint(equalTo: declineButton.centerYAnchor),
            sendRequestButton.widthAnchor.constraint(equalToConstant: 120),
            sendRequestButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        activeButtonsConstraints = [
            declineButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            declineButton.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor),
            sendRequestButton.leadingAnchor.constraint(equalTo: declineButton.trailingAnchor, constant: 40),
            sendRequestButton.centerYAnchor.constraint(equalTo: declineButton.centerYAnchor),
        ]
    }
    
    private func setupButtonsForSearch() {
        
        self.addSubview(sendRequestButton)
        sendRequestButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            sendRequestButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
//            sendRequestButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            sendRequestButton.widthAnchor.constraint(equalToConstant: 120),
            sendRequestButton.heightAnchor.constraint(equalToConstant: 40),
            
//            declineButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
//            declineButton.centerYAnchor.constraint(equalTo: sendRequestButton.centerYAnchor),
            declineButton.widthAnchor.constraint(equalToConstant: 45),
            declineButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        activeButtonsConstraints = [
            sendRequestButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            sendRequestButton.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor),
            declineButton.leadingAnchor.constraint(equalTo: sendRequestButton.trailingAnchor, constant: 40),
            declineButton.centerYAnchor.constraint(equalTo: sendRequestButton.centerYAnchor),
        ]
    }
    
    private func swapButtons() {
        if alrdSentInv != nil, alrdSentInv == true {
            activeButtonsConstraints = [
                declineButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
                declineButton.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor),
                sendRequestButton.leadingAnchor.constraint(equalTo: declineButton.trailingAnchor, constant: 40),
                sendRequestButton.centerYAnchor.constraint(equalTo: declineButton.centerYAnchor),
            ]
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
                self.declineButton.alpha = 1.0
                self.sendRequestButton.alpha = 0.0
            }
        } else {
            activeButtonsConstraints = [
                    sendRequestButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                    sendRequestButton.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor),
                    declineButton.leadingAnchor.constraint(equalTo: sendRequestButton.trailingAnchor, constant: 40),
                    declineButton.centerYAnchor.constraint(equalTo: sendRequestButton.centerYAnchor),
            ]
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
                self.sendRequestButton.alpha = 1.0
                self.declineButton.alpha = 0.0
            }
        }
    }
    
    //MARK: - Selectors
    @objc private func sendRequestTapped() {
        delegate?.sendFriendshipReq(to: self.user) { success in
            if success {
                self.alrdSentInv = true
                self.swapButtons()
            }
        }
    }
    
    @objc private func declineButtonTapped() {
//        delegate?.declineFriendShipReq(from: self.user)
        delegate?.declineWhomSentReq(from: self.user) { success in
            if success {
                self.alrdSentInv = false
                self.swapButtons()
            }
        }
    }
    
    //MARK: - Configure
    public func configure(with user: User, alrdSentInv: Bool? = nil) {
            if alrdSentInv != nil, alrdSentInv == true {
                self.alrdSentInv = true
                sendRequestButton.alpha = 0.0
                declineButton.alpha = 1.0
                setupButtonWhomSent()
            } else {
                self.alrdSentInv = false
                declineButton.alpha = 0.0
                sendRequestButton.alpha = 1.0
                setupButtonsForSearch()
            }
            sendRequestButton.addTarget(self, action: #selector(sendRequestTapped), for: .touchUpInside)
            declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
        self.user = user
        self.username.text = user.username
    }
}
