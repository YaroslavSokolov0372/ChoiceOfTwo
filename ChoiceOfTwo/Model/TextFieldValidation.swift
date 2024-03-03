//
//  TextValidationPublished.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation
import Combine

class TextFieldValidation: Validatable {
    
    enum TextFieldType {
        case email
        case password
        case username
    }
    
    private var textFieldType: TextFieldType
    @Published var text: String = ""
    @Published var textState: FieldState = .idle
    
    init(textFieldType: TextFieldType) {
        self.textFieldType = textFieldType
    }

    
    //MARK: - Validation
    
    func validate(publisher: AnyPublisher<String, Never>) -> AnyPublisher<FieldState, Never> {
        switch self.textFieldType {
        case .username:
            Publishers.CombineLatest4(
                isEmpty(publisher: publisher),
                isToShort(publisher: publisher, count: 4),
                hasNumbers(publisher: publisher),
                hasSpecialCharacters(publisher: publisher)
            ).map {
                if $0.0 { return FieldState.error(.empty)}
                if $0.1 { return FieldState.error(.tooShortName)}
                if $0.2 { return FieldState.error(.nameCantContainNumbers)}
                if $0.3 { return FieldState.error(.nameCantContainNumbers)}
                return FieldState.success
            }.eraseToAnyPublisher()
        case .password:
            Publishers.CombineLatest(
                isEmpty(publisher: publisher),
                isToShort(publisher: publisher, count: 6)
            ).map {
                if $0.0 { return FieldState.error(.empty) }
                if $0.1 { return FieldState.error(.tooShortPassword)}
                return FieldState.success
            }.eraseToAnyPublisher()
        case .email:
            Publishers.CombineLatest(
                isEmpty(publisher: publisher),
                isEmail(with: publisher)
            ).map {
                if $0.0 { return FieldState.error(.empty)}
                if $0.1 { return FieldState.error(.tooShortName)}
                return FieldState.success
            }.eraseToAnyPublisher()
        }
    }
}



enum FieldState: Equatable {
    case idle
    case error(ErrorState)
    case success
    
    enum ErrorState: Equatable {
        
        case empty
        case invalidEmail
        case tooShortPassword
        case nameCantContainNumbers
        case nameCantContainSpecialChars
        case tooShortName
        case nicknameAlreadyExist
        case emailAlreadyExist
        case isTooLong
        case custom(String)
        
        var description: String {
            switch self {
            case .empty:
                return "Field is empty."
            case .invalidEmail:
                return "Invalid email."
            case .tooShortPassword:
                return "Password is to short"
            case .nameCantContainNumbers:
                return "Name can't contain numbers."
            case .nameCantContainSpecialChars:
                return "Name can't contain special characters."
            case .tooShortName:
                return "Name is to short"
            case .custom(let string):
                return string
            case .nicknameAlreadyExist:
                return "Account with this name already exist"
            case .emailAlreadyExist:
                return "Account with this email already exist"
            case .isTooLong:
                return "Is too long"
            }
        }
    }
}
