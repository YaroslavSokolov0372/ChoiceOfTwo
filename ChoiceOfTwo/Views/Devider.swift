//
//  Devider.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit

class Devider: UIView {
    
    init(color: UIColor? = nil) {
        super.init(frame: .zero)
        if color != nil {
            self.backgroundColor = color
        } else {
            self.backgroundColor = .black
        }
        self.alpha = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

