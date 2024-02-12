//
//  TextValidationPublished.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation
import Combine

class TextValidationPublished {
    
    @Published var text: String = ""
    @Published var textState: FieldState = .idle
    
    enum FieldState: Equatable {
        case idle
        case error(ErrorState)
        case success
    }

    enum ErrorState {
        
        case empty
        case tooShort
        case numbers
        case specialChar
        
        var description: String {
            switch self {
            case .empty:
                return "Field is empty."
            case .numbers:
                return "Name is to short"
            case .specialChar:
                return "Name can't contain numbers."
            case .tooShort:
                return "Name can't contain special characters."
            }
        }
    }
    
    //MARK: - Validation
    var isEmpty: AnyPublisher<Bool, Never> {
        $text
            .map({ $0.isEmpty })
            .eraseToAnyPublisher()
    }
    
    var isTooShort: AnyPublisher<Bool, Never> {
        $text
            .map({ $0.count < 3 })
            .eraseToAnyPublisher()
    }
    
    var hasNumbers: AnyPublisher<Bool, Never> {
        $text
            .map({ $0.hasNumbers() })
            .eraseToAnyPublisher()
    }
    
    var hasSpecialCharacters: AnyPublisher<Bool, Never> {
        $text
            .map({ $0.hasSpecialCharacters() })
            .eraseToAnyPublisher()
    }
    
    func startValidation() {
        guard self.textState == .idle else { return }
        
        Publishers.CombineLatest4(
            isEmpty,
            isTooShort,
            hasNumbers,
            hasSpecialCharacters
        ).map({
            if $0.0 { return FieldState.error(.empty) }
            if $0.1 { return FieldState.error(.tooShort) }
            if $0.2 { return FieldState.error(.numbers) }
            if $0.3 { return FieldState.error(.specialChar) }
            return FieldState.success
        })
        .assign(to: &$textState)
    }
}


