//
//  FriendCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit

class FriendCellView: UICollectionViewCell {
 
    
    //MARK: UI Components
//    private let image: UIImageView = {
//        let iv = UIImageView()
//        let im = UIImage(named: "Plus")!
//            .withRenderingMode(.alwaysTemplate)
//            .resize(targetSize: CGSize(width: 40, height: 40))
//        //            .resizeUI(size: CGSize(width: 100, height: 100))
//        iv.backgroundColor = .white
//        iv.layer.borderColor = UIColor.mainPurple.cgColor
//        iv.layer.borderWidth = 1
//        iv.layer.cornerRadius = 30
//        iv.image = im
////        iv.contentMode = .scaleToFill
//        
//        //        iv.image = iv.image?.resize(targetSize: CGSize(width: 20, height: 20))
//        return iv
//    }()
    
    
    private let profileImageButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
//        let im = UIImage(named: image)!.withRenderingMode(.alwaysTemplate)
        configuration.background.strokeColor = .mainPurple
        configuration.baseForegroundColor = .mainPurple
        configuration.background.cornerRadius = 30
//        configuration.image = im
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
        self.layer.cornerRadius = 30
        setupUI()
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
    
    
    //MARK: Configure
    public func configure(isFirst: Bool) {
        if isFirst {
            let im = UIImage(named: "Plus")!.withRenderingMode(.alwaysTemplate)
            profileImageButton.setImage(im, for: .normal)
            name.text = "Add Friend"
        }
    }
    
    public func configureFirst() {
        
    }
}

