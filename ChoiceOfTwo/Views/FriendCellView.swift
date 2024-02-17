//
//  FriendCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit

class FriendCellView: UICollectionViewCell {
 
    
    //MARK: UI Components
    private let image: UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = .black
        let im = UIImage(named: "Plus")!
            .withRenderingMode(.alwaysTemplate)
//            .resize(targetSize: CGSize(width: 30, height: 30))
            
        im.withTintColor(.mainPurple)
        
        iv.tintColor = .mainPurple
        iv.tintColor.setStroke()
        iv.backgroundColor = .mainPurple
        iv.layer.cornerRadius = 30
        iv.image = im
        return iv
    }()
    
    private let name: UILabel = {
      let label = UILabel()
        label.text = "Yaroslav Sokolov"
        label.numberOfLines = 2
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
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.image.heightAnchor.constraint(equalToConstant: 60),
            self.image.widthAnchor.constraint(equalToConstant: 60),
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.name.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 7),
            self.name.centerXAnchor.constraint(equalTo: self.image.centerXAnchor),
            self.name.widthAnchor.constraint(equalToConstant: 90),
//            self.name.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    
    //MARK: Configure
    public func configure() {
        
    }
}
