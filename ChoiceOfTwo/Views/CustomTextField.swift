//
//  CustomTextField.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import UIKit


class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case email
        case password
        case username
    }
    

    
    //MARK: - Variables
    let textFieldType: CustomTextFieldType
    
    //MARK: - Lifecycle
    init(textFieldType: CustomTextFieldType, strokeColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        
        switch textFieldType {
        case .username:
            self.placeholder = "Username"
            self.textContentType = .username
        case .email:
            self.placeholder = "Email address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.textContentType = .password
        }
        
        if strokeColor != nil {
            self.layer.borderColor = strokeColor!.cgColor
            self.layer.borderWidth = 1
        }
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor!
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
