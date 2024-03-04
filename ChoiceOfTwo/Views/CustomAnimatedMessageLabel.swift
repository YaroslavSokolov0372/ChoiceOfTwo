//
//  CustomAnimatedMessageView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 03/03/2024.
//

import UIKit

class CustomAnimatedMessageLabel: UILabel {
    
    
    //MARK: - Variabels
    private var isPlaying = false
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.textColor = .white
        self.font = .nunitoFont(size: 14, type: .medium)
        self.clipsToBounds = true
        self.numberOfLines = 0
        self.textAlignment = .center
        self.layer.cornerRadius = 12
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Animations
    private func showLabel(completionHandler: @escaping (_ onFinish: Bool) -> () ) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut) {

//        UIView.animate(withDuration: 0.3) {
            guard let superview = self.superview else {
                print("Havent found superview")
                return
            }
            self.frame.origin.y = self.frame.origin.y - (superview.frame.height * 0.13)
        } completion: { finished in
            if finished {
                completionHandler(true)
            }
        }
    }
    
    private func hideLabel() {
        UIView.animate(withDuration: 0.6, delay: 1.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseIn) {
            guard let superview = self.superview else {
                print("Havent found superview")
                return
            }
            self.frame.origin.y = self.frame.origin.y + (superview.frame.height * 0.13)
        } completion: { finished in
            if finished {
                self.isPlaying = false
            }
        }
    }
    
    func playAnimation() {
        if !isPlaying {
            isPlaying = true
            showLabel { [weak self] onFinish in
                self?.hideLabel()
            }
        }
    }
    
    
    func configure(message: String, strokeColor: UIColor) {
        self.text = message
        
        self.layer.borderColor = strokeColor.cgColor
        self.textColor = strokeColor
        self.layer.borderWidth = 1
    }
}
