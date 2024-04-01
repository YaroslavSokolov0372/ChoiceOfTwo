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
    let circleImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = .mainLightGray
        iv.alpha = 1.0
        iv.isUserInteractionEnabled = true
        iv.isUserInteractionEnabled = true
        return iv
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        //MARK: - Setup UI
    private func setupUI() {

        self.addSubview(circleImage)
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.circleImage.heightAnchor.constraint(equalToConstant: 60),
            self.circleImage.widthAnchor.constraint(equalToConstant: 60),
            self.circleImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.circleImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.name.topAnchor.constraint(equalTo: self.circleImage.bottomAnchor, constant: 7),
            self.name.centerXAnchor.constraint(equalTo: self.circleImage.centerXAnchor),
            self.name.widthAnchor.constraint(equalToConstant: 95),
        ])
    }
    
    //MARK: - Selectors
    @objc private func profilleImageTapped() {
        print("I am here")
        friendsDelegate?.friendProfileTapped(friend: friend, cell: self)
    }
    
    @objc private func plusButtonTapped() {
        print("I am here")
        addFriendsDelegate?.plusButtonTapped()
    }
    
    //MARK: Configure
    public func configure(isFirst: Bool, with user: User? = nil) {
        if isFirst {
            let im = UIImage(named: "Plus")!.withRenderingMode(.alwaysTemplate).resize(targetSize: CGSize(width: 40, height: 40))
            circleImage.image = im
            circleImage.contentMode = .center
            circleImage.tintColor = .mainPurple
            
            circleImage.image?.withTintColor(.mainPurple)
            circleImage.layer.borderColor = UIColor.mainPurple.cgColor
            circleImage.layer.borderWidth = 1
            circleImage.backgroundColor = .white
            name.text = "Add Friend"
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped))
            circleImage.addGestureRecognizer(gesture)
        }
        
        if let user = user {
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(profilleImageTapped))
            circleImage.addGestureRecognizer(gesture1)
            circleImage.contentMode = .scaleAspectFill
            friend = user
            name.text = user.username
        }
    }
    
    public func configureFirst() {
        
    }
}

