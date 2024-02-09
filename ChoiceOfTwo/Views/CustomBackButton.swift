//
//  CustomBackButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import UIKit

class CustomBackButton: UIButton {

    
    
        
    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        
        self.contentMode = .scaleAspectFill
        self.setImage(UIImage(named: "ArrowImage")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.transform = CGAffineTransformMakeRotation(CGFloat(Double.pi / 1))
        self.imageView?.tintColor = .mainPurple
        self.tintColor = .mainPurple
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
