//
//  MatchedAnimeCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 27/03/2024.
//

import UIKit

class MatchedAnimeCell: UICollectionViewCell {
    
    
    //MARK: - UI Components
    let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    private let animeName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .mainPurple
        label.numberOfLines = 3
        label.font = .nunitoFont(size: 20, type: .bold)
        return label
    }()
    
    private var activeNameConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeNameConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeNameConstraints)
        }
    }
    
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configure
    public func configure(with anime: Anime) {
        self.coverImage.setImageFromStringrURL(stringUrl: anime.coverImage?.extraLarge ?? "")
        
        
        self.animeName.text = anime.title
        let textHeight = self.animeName.text!.height(constraintedWidth: self.frame.width, font: UIFont.nunitoFont(size: 18, type: .bold)!)
        let numberOfRows = textHeight / 18
        
        if numberOfRows > 4 {
            self.activeNameConstraints = [
                self.animeName.heightAnchor.constraint(equalToConstant: 14 * 4),
            ]
            self.animeName.numberOfLines = 4
        } else {
            self.activeNameConstraints = [
                self.animeName.heightAnchor.constraint(equalToConstant: textHeight),
            ]
            self.animeName.numberOfLines = Int(numberOfRows)
        }
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.addSubview(coverImage)
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(animeName)
        animeName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.coverImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            self.coverImage.heightAnchor.constraint(equalToConstant: 350),
            self.coverImage.topAnchor.constraint(equalTo: self.topAnchor), 
            
            self.animeName.topAnchor.constraint(equalTo: self.coverImage.bottomAnchor, constant: 10),
            self.animeName.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        
        self.activeNameConstraints = [
            self.animeName.heightAnchor.constraint(equalToConstant: 20),
        ]
    }
}
