//
//  CustomButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import UIKit

class CustomButton: UIButton {

    
    enum CustomButtonType {
        case small
        case big
        case medium
    }

    private let type: CustomButtonType
    
    //MARK: - Lifecycle
    init(text: String, type: CustomButtonType, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        self.type = type
        super.init(frame: .zero)
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = .white
        }
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.setTitle(text, for: .normal)
        
        if textColor != nil {
            self.setTitleColor(textColor, for: .normal)
        } else {
            self.setTitleColor(.mainPurple, for: .normal)
        }
        
        switch type {
        case .small:
            self.titleLabel?.font = .nunitoFont(size: 16, type: .light)
            return
        case .big:
            self.titleLabel?.font = .nunitoFont(size: 22, type: .bold)
            return
        case .medium:
            self.titleLabel?.font = .nunitoFont(size: 18, type: .medium)
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
