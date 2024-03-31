//
//  TagCellViewCollectionViewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 31/03/2024.
//

import UIKit

class TagCellView: UICollectionViewCell {
    
    //MARK: - UI Components
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.font = .nunitoFont(size: 15, type: .regular)
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
        
        self.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            tagLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
    
    
    //MARK: - Configure
    public func configure(with string: String) {
        self.tagLabel.text = string
    }
}
