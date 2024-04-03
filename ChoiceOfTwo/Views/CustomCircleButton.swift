//
//  CustomBackButton.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import UIKit

class CustomCircleButton: UIButton {

    
    
        
    //MARK: - Lifecycle
    init(customImage: String? = nil, rotate: CGFloat? = nil, resized: CGSize? = nil, imageColor: UIColor? = nil, backgroundColor: UIColor? = nil, stroke: Bool = false, cornerRadius: CGFloat? = nil) {
        super.init(frame: .zero)
        

        if resized != nil {
            let image = UIImage(
                named: customImage == nil ? "ArrowImage" : customImage!
            )?.resize(targetSize: resized!).withRenderingMode(.alwaysTemplate)
            self.setImage(image, for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
            
        } else {
            self.setImage(
                UIImage(
                    named: customImage == nil ? "ArrowImage" : customImage!
                )?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
        }
        
        if imageColor != nil {
            if stroke {
                self.layer.borderWidth = 1
                self.layer.borderColor = imageColor!.cgColor
            }
            self.tintColor = imageColor
        } else {
            if stroke {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor(named: "MainPurple")?.cgColor
            }
            self.tintColor = .mainPurple
        }
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = .white
        }
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        } else {
            self.layer.cornerRadius = 20
        }
        
        if rotate != nil {
            self.transform = CGAffineTransformMakeRotation(CGFloat(Double.pi / rotate!))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

