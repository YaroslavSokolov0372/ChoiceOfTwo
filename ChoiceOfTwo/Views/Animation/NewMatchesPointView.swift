//
//  NewMatchesPointView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 24/03/2024.
//

import UIKit

class NewMatchesPointView: UIView {
    
    
    var visible: Bool = false {
        didSet {
            if visible == true {
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
//                    
//                    self.alpha = 1.0
//                }
                show { }
            } else {
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
//                    self.alpha = 0.0
//                }
                hide { }
            }
        }
    }
    
    init(backgroundColor: UIColor, cornerRadius: CGFloat? = nil) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.alpha = 0.0
        if cornerRadius != nil {
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius!
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show(competion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.alpha = 1.0
        } completion: { _ in
            competion()
        }
    }
    
    func hide(competion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.alpha = 0.0
        } completion: { _ in
            competion()
        }
    }
}
