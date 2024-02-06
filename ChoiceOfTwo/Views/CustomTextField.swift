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
    private let textFieldType: CustomTextFieldType
    
    
    //MARK: - Lifecycle
    init(textFieldType: CustomTextFieldType) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
