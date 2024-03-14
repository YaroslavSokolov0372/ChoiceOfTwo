//
//  ProposedCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import UIKit

class ProposedCellView: UICollectionViewCell {
        
    //MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.font = .nunitoFont(size: 15, type: .regular)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
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
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        contentView.autoresizingMask = [.flexibleWidth]
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    
    //MARK: - Configure
    public func configure(with string: String) {
        label.text = string
    }
}
