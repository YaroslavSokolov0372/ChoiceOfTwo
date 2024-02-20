//
//  LoginController_UITextFieldDelegate.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation
import UIKit

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let textField = textField as! CustomTextField
        switch textField.textFieldType {
        case .email:
            vm.email.text = textField.text ??  ""
        case .password:
            vm.password.text = textField.text ?? ""
        case .username:
            break
        }
        return true
    }
    

}
