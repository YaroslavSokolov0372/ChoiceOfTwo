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
        let customTextField = textField as! CustomTextField
        if customTextField.textFieldType == .password {
            textField.moveTextField(textField, moveDistance: -30, up: true) { movement in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            }
        }
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        let customTextField = textField as! CustomTextField
        if customTextField.textFieldType == .password {
            textField.moveTextField(textField, moveDistance: -30, up: false) { movement in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            }
        }
    }
}
