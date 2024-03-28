//
//  HistoryCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit

class HistoryCellView: UICollectionViewCell {
    
    
    //MARK: - UI Components
    private let skeletonView = SkeletonHistoryCard()
    
    
    
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(skeletonView)
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skeletonView.topAnchor.constraint(equalTo: self.topAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            skeletonView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    //MARK: - Configure
    public func configure() {
        
    }
}
