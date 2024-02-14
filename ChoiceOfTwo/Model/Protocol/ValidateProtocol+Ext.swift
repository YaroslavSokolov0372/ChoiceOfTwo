//
//  ValidateProtocol+Ext.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation
import Combine
import UIKit

protocol Validatable {
    func validate(publisher: AnyPublisher<String, Never>) -> AnyPublisher<FieldState, Never>
}



extension Validatable {
    func isEmpty(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.isEmpty })
            .eraseToAnyPublisher()
    }
    
    func isToShort(publisher: AnyPublisher<String, Never>, count: Int) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.count < 3 })
            .eraseToAnyPublisher()
    }
    
    func hasNumbers(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.hasNumbers() })
            .eraseToAnyPublisher()
    }
    
    func hasSpecialCharacters(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.hasSpecialCharacters() })
            .eraseToAnyPublisher()
    }
    
    func isEmail(with publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map { $0.isValidEmail() }
            .eraseToAnyPublisher()
    }
}
