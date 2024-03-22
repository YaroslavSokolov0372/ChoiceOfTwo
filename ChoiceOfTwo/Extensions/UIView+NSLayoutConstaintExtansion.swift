//
//  UIView+NSLayoutConstaintExtansion.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/03/2024.
//

import Foundation
import UIKit

extension UIView {
    
    func setupSizeForDetailInfo() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: self.superview!.layoutMarginsGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 15),
            self.heightAnchor.constraint(equalToConstant: 400),
            self.widthAnchor.constraint(equalToConstant: 275)
        ])
    }
}
