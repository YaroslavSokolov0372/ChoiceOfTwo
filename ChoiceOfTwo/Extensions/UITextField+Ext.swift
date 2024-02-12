//
//  UITextField+Ext.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation
import Combine
import UIKit


extension UITextField {
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as! UITextField).text }
            .eraseToAnyPublisher()
    }
    
    func validationStateChanged(state: TextValidationPublished.FieldState) {
        print(state)
        switch state {
        case .idle:
            break
        case .error(let errorState):
            return
//            errorLabel.text = errorState.description
//            errorLabel.isHidden = false
        case .success:
            return
//            errorLabel.text = nil
//            errorLabel.isHidden = true
        }
     }
}
