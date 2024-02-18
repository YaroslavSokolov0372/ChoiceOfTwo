//
//  SkeletonHistoryCard.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit

class SkeletonHistoryCard: UIView {
    
    
    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
//        self.backgroundColor = .lightGray
        self.backgroundColor = .mainGray
        self.layer.borderColor = UIColor.mainPurple.cgColor
        self.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
