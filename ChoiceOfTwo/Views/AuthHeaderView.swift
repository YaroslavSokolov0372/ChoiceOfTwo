//
//  AuthHeader.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import UIKit

class AuthHeaderView: UIView {

    
    //MARK: UI Components
    private let imageLogoView: UIImageView = {
      let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "LogoImage")
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        return iv
    }()
    
//    private let appName: UILabel = {
//        let label = UILabel()
//        label.font = .nunitoFont(size: 30, type: .bold)
//        label.text = "CHOICE OF TWO"
//        label.textColor = .white
//        return label
//    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
//        label.textColor = .white
        label.textColor = .mainPurple
//        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.font = .nunitoFont(size: 26, type: .bold)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
//        label.textColor = .white
        
        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.font = .nunitoFont(size: 16, type: .regular)
        return label
    }()
    
    //MARK: - Lifecycle
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        self.addSubview(imageLogoView)
        imageLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageLogoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            self.imageLogoView.widthAnchor.constraint(equalToConstant: 100),
//            self.imageLogoView.heightAnchor.constraint(equalToConstant: 100),
            self.imageLogoView.widthAnchor.constraint(equalToConstant: 140),
            self.imageLogoView.heightAnchor.constraint(equalToConstant: 140),
            
            self.titleLabel.topAnchor.constraint(equalTo: imageLogoView.bottomAnchor, constant: 5),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
