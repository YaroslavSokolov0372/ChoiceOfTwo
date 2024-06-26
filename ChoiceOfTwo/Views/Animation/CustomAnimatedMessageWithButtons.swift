//
//  CustomAnimatedGameInvView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/03/2024.
//

import UIKit


protocol AnimatedMessageWithButtonsViewDelegate {
    
    
    func declineInvite(of friend: User)
    
    func accpetInvite(of friend: User)
    
    func deleteFriend(_ friend: User)
    
}

class CustomAnimatedMessageWithButtons: UIView {
    
    
    enum MessageType {
        case invite
        case delete
    }
    
    //MARK: - Variables
    var delegate: AnimatedMessageWithButtonsViewDelegate?
    private var users: [User] = []
    private var played = 0
    private var isPlaying = false
    
    public var hideAnimation = UIViewPropertyAnimator()
    
    //MARK: - UI Components
    private let text: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 14, type: .medium)
        label.text = "Yaroslav Sokolov sent an invite! Will you play?"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    private let declineButton = CustomCircleButton(customImage: "Plus", rotate: 4, resized: CGSize(width: 27, height: 27), imageColor: .white, backgroundColor: .mainPurple, cornerRadius: 17)
    private let acceptButton = CustomCircleButton(customImage: "CheckMark", resized: CGSize(width: 27, height: 27), imageColor: .white, backgroundColor: .mainPurple, cornerRadius: 17)

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.backgroundColor = .white
        self.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(acceptButton)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            text.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            text.widthAnchor.constraint(equalToConstant: 160),
            text.heightAnchor.constraint(equalToConstant: 40),
            
            declineButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            declineButton.widthAnchor.constraint(equalToConstant: 35),
            declineButton.heightAnchor.constraint(equalToConstant: 35),
            declineButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            acceptButton.trailingAnchor.constraint(equalTo: declineButton.leadingAnchor, constant: -10),
            acceptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 35),
            acceptButton.heightAnchor.constraint(equalToConstant: 35),
            
        ])
    }
    
    //MARK: Selectors
    @objc private func declineButtonTapped() {
        delegate?.declineInvite(of: self.users[played - 1])
    }
    
    @objc private func acceptButtonTapped() {
        delegate?.accpetInvite(of: self.users[played - 1])
    }
    
    @objc private func keepFriendTapped() {
        self.hideAnimation.startAnimation()
    }
    
    @objc private func deleteFriendTapped() {
        delegate?.deleteFriend(self.users[played - 1])
    }
    
    //MARK: Configure
    public func configure(with user: User, type: MessageType) {
        switch type {
        case .invite:
            self.text.text = "\(user.username) sent an invite! Will you play?"
            self.layer.borderColor = UIColor.mainPurple.cgColor
            self.text.textColor = .mainPurple
            declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
            acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        case .delete:
            self.layer.borderColor = UIColor.mainRed.cgColor
            self.text.textColor = .mainRed
            self.declineButton.backgroundColor = .mainRed
            self.acceptButton.backgroundColor = .mainRed
            self.text.text = "Are you sure you want delete \(user.username)?"
            declineButton.addTarget(self, action: #selector(keepFriendTapped), for: .touchUpInside)
            acceptButton.addTarget(self, action: #selector(deleteFriendTapped), for: .touchUpInside)
        }
    }
    
    //MARK: - Animations
     func showLabel(completionHandler: @escaping (_ onFinish: Bool) -> () ) {
         
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut) {
            guard let superview = self.superview else {
                print("Havent found superview")
                return
            }
            self.frame.origin.x = superview.frame.minX - 10
        } completion: { finished in
            if finished {
                completionHandler(true)
            }
        }
         
    }
    
    private func hideLabel(completion: @escaping () -> Void) {
        let playedInMoment = played
        self.hideAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
        self.hideAnimation.addAnimations {
            guard let superview = self.superview else {
                print("Havent found superview")
                return
            }
            self.frame.origin.x = superview.frame.minX - 350
        }
        self.hideAnimation.addCompletion { finished in
            completion()
            self.alpha = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if playedInMoment == self.played {
                self.hideAnimation.startAnimation()
            }
        }
    }
    
    func playAnimation(users: [User], type: MessageType) {
        self.users.append(contentsOf: users)
        if !isPlaying {
            isPlaying = true
            self.alpha = 1.0
            configure(with: self.users[played], type: type)
            played += 1
            showLabel { [weak self] onFinish in
                self?.hideLabel() {
                    self?.isPlaying = false
                    if self!.played < self!.users.count {
                        self?.configure(with: self!.users[self!.played], type: type)
                        self?.playAnimation(users: [], type: type)
                    }
                }
            }
        }
    }
}
