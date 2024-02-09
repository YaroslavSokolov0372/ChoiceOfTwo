//
//  CustomImageAuthButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 09/02/2024.
//

import UIKit

class CustomImageAuthButton: UIButton {

    
    init(image: String, title: String) {
        super.init(frame: .zero)
        
        let im = UIImage(named: image)!.resizeImage(targetSize: CGSize(width: 35, height: 35))
        
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .white
        configuration.title = title
        configuration.baseForegroundColor = .mainPurple
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.nunitoFont(size: 18, type: .medium)!]))
        configuration.image = im
        configuration.imagePadding = 20
        self.configuration = configuration
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.titleLabel?.font = .nunitoFont(size: 18, type: .medium)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
