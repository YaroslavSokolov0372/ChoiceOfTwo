//
//  InteractFriendView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/03/2024.
//

import UIKit

protocol InteractFriendDelegate {
    
    func inviteFriendTapped(_ friend: User)
    
    func deleteFriendTapped(_ friend: User)
}

class InteractFriendView: UIView {
    
    
    //MARK: - UI Component
    private let inviteFriendButton = CustomButton(text: "Invite Friend", type: .small, textColor: .mainPurple)
    private let deleteFriendButton = CustomButton(text: "Delete Friend", type: .small, textColor: .mainRed)
    private let devider = Devider(color: .mainDarkGray)
    private var friend: User!
    private var isOpened = false
    public var delegate: InteractFriendDelegate?
    
    
    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        self.alpha = 0.0
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mainDarkGray.cgColor
        deleteFriendButton.addTarget(self, action: #selector(deleteFriendTapped), for: .touchUpInside)
        inviteFriendButton.addTarget(self, action: #selector(inviteFriendTapped), for: .touchUpInside)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(inviteFriendButton)
        inviteFriendButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(devider)
        devider.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(deleteFriendButton)
        deleteFriendButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            inviteFriendButton.topAnchor.constraint(equalTo: self.topAnchor),
            inviteFriendButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inviteFriendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inviteFriendButton.heightAnchor.constraint(equalToConstant: 45),
            
            devider.topAnchor.constraint(equalTo: inviteFriendButton.bottomAnchor, constant: 3),
            devider.centerXAnchor.constraint(equalTo: inviteFriendButton.centerXAnchor),
            devider.widthAnchor.constraint(equalToConstant: 90),
            devider.heightAnchor.constraint(equalToConstant: 1),
            
            deleteFriendButton.topAnchor.constraint(equalTo: devider.bottomAnchor, constant: 3),
            deleteFriendButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            deleteFriendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deleteFriendButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    //MARK: - Selectors
    
    @objc private func inviteFriendTapped() {
        delegate?.inviteFriendTapped(friend)
    }
    
    @objc private func deleteFriendTapped() {
        delegate?.deleteFriendTapped(friend)
    }
    
    //MARK: - Animations
    
    public func hide(cell: UICollectionViewCell, completion: @escaping () -> Void) {
        let frame = cell.superview!.convert(cell.frame, to: self.superview)
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.0
        } completion: { finished in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {
                self.frame = CGRect(x: (frame.midX - 60), y: (frame.maxY + 20), width: 120, height: 100)
                
            } completion: { finished in
                completion()
            }
        }
    }
    
    public func showUnder(cell: UICollectionViewCell) {
        
        let frame = cell.superview!.convert(cell.frame, to: self.superview)
        self.frame = CGRect(x: (frame.midX - 60), y: (frame.maxY + 20), width: 120, height: 100)
        
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) {
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: .curveEaseInOut) {
            self.frame = CGRect(x: (frame.midX - 60), y: (frame.maxY), width: 120, height: 100)
            self.alpha = 1.0
        }
    }
    
    public func configure(with user: User, completion: @escaping (_ isTheSame: Bool, _ isOpened: Bool) -> Bool) {
        if self.friend == nil || self.friend?.uid != user.uid {
            self.friend = user
            isOpened = completion(false, false)
        } else {
            let result = completion(true, isOpened)
            isOpened = result
        }
    }
}
