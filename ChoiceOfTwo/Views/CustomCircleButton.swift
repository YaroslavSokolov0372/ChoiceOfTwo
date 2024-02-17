//
//  CustomBackButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import UIKit

class CustomCircleButton: UIButton {

    
    
        
    //MARK: - Lifecycle
    init(customImage: String? = nil, rotate: CGFloat? = nil, resized: CGSize? = nil, imageColor: UIColor? = nil) {
        super.init(frame: .zero)
        
        self.contentMode = .scaleAspectFill
        
        if rotate != nil {
            self.transform = CGAffineTransformMakeRotation(CGFloat(Double.pi / rotate!))
        }
        if resized != nil {
            let image = UIImage(
                named: customImage == nil ? "ArrowImage" : customImage!
            )?.withRenderingMode(.alwaysTemplate).resize(targetSize: resized!)
            image?.withTintColor(.mainPurple)
            self.setImage(image, for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
            
        } else {
            self.setImage(
                UIImage(
                    named: customImage == nil ? "ArrowImage" : customImage!
                )?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
        }
        
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

