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
    
    func validationStateChanged(state: FieldState, complition: @escaping (_ hasError: Bool, _ error: FieldState.ErrorState?) -> Void) {
        print(state)
        switch state {
        case .idle:
            break
        case .error(let errorState):
            //MARK: - show error in UI
            complition(true, errorState)
            return
        case .success:
            //MARK: - show error in UI
            complition(false, nil)
            return
        }
     }
}
