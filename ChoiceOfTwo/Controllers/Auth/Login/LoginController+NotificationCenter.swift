//
//  LoginController+NotificationCenter.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 03/03/2024.
//

import Foundation
import UIKit

extension LoginController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIControl.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrameValue.cgRectValue
        let keyboardTopY = self.view.frame.height - keyboardRectangle.height
        
        if  emailField.isFirstResponder {
            let textFieldBottomPoint = CGPoint(x: 0, y: emailField.frame.origin.y + emailField.frame.height)
            let textFieldBottomY = scrollView.convert(textFieldBottomPoint, to: view).y
            let distanceHeight = abs(keyboardTopY - textFieldBottomY)
//            print(distanceHeight)
            
            if distanceHeight < 0 {
                print("DEBUG: - Distance less than 0 ", distanceHeight)
                scrollView.setContentOffset(CGPoint(x: 0, y: -(distanceHeight)), animated: true)
            } else if distanceHeight > 0 {
                print("DEBUG: - Distance more than 0 ", distanceHeight)
                scrollView.setContentOffset(CGPoint(x: 0, y: -distanceHeight), animated: true)
            }
        }
        
        if passwordField.isFirstResponder {
            let textFieldBottomPoint = CGPoint(x: 0, y: passwordField.frame.origin.y + passwordField.frame.height)
            let textFieldBottomY = scrollView.convert(textFieldBottomPoint, to: view).y
            let distanceHeight = abs(keyboardTopY - textFieldBottomY)
            
            if distanceHeight < 0 {
                print("DEBUG: - Distance less than 0 ", distanceHeight)
                scrollView.setContentOffset(CGPoint(x: 0, y: -distanceHeight), animated: true)
            } else if distanceHeight > 0 {
                print("DEBUG: - Distance more than 0 ", distanceHeight)
                scrollView.setContentOffset(CGPoint(x: 0, y: distanceHeight), animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
}
