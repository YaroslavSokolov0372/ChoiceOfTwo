//
//  EntryController+UITextFieldDelegate.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation
import UIKit

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let textField = textField as! CustomTextField
        switch textField.textFieldType {
        case .email:
            vm.email.text = textField.text ??  ""
        case .password:
            vm.password.text = textField.text ?? ""
        case .username:
            vm.username.text = textField.text ?? ""
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let customTextField = textField as! CustomTextField
        
        
//        print(textField.superview?.keyboardLayoutGuide.layoutFrame.size.height)
//        print(textField.superview?.keyboardLayoutGuide.frame(in: textField.superview!))
//        print(textField.keyboardLayoutGuide.layoutFrame.height)
//        let textfieldCenter = textField.superview!.convert(textField.center, to: textField.superview)
//        let parentCenter = textField.superview?.center
//        let moveDistance = parentCenter!.y - textfieldCenter.y
//        print(Int(moveDistance))
        
//        textField.becomeFirstResponder()
//        if textField.isFirstResponder {
//            let superY = textField.superview?.frame.origin.y
//            let textFieldY = textField.frame.origin.y
//            print(self.scrollView.contentOffset.y)
//            self.scrollView.setContentOffset(CGPoint(x: 0, y: superY! + textFieldY), animated: true)
//            self.scrollView.contentOffset.y = (superY! - textFieldY)
//            print("i am here")
//        }
        
        
//        if customTextField.textFieldType == .password {
////            textField.moveTextField(textField, moveDistance: -80, up: true) { movement in
//            textField.moveTextField(textField, moveDistance: Int(moveDistance), up: true) { movement in
////                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
//                self.scrollView.contentOffset.y =  self.scrollView.contentOffset.y - movement
//            }
//        }
        
//        if customTextField.textFieldType == .email {
////            textField.moveTextField(textField, moveDistance: -40, up: true) { movement in
//            textField.moveTextField(textField, moveDistance: Int(moveDistance), up: true) { movement in
////                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
//                self.scrollView.contentOffset.y =  self.scrollView.contentOffset.y - movement
//            }
//        }
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let textField = textField as! CustomTextField
        switch textField.textFieldType {
        case .email:
            if !madeBindingForEmail {
                self.emailListener()
                self.bindEmail()
                self.bindEmailForIndicator()
                madeBindingForEmail = true
                print("DEBUG:", "Binded email")
            }
            
        case .password:
            if !madeBindingForPassword {
                self.passwordListener()
                self.bindPassword()
                self.bindPasswordForIndicator()
                madeBindingForPassword = true
                print("DEBUG:", "Binded password")
            }
        case .username:
            if !madeBindingForUsername {
                self.usernameListener()
                self.bindUsername()
                self.bindUsernameForIndicator()
                madeBindingForUsername = true
                print("DEBUG:", "Binded username")
            }
        }
        return true
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
