//
//  ValidateProtocol+Ext.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation
import Combine
import UIKit
//import Contacts


protocol Validatable {
    func validate(publisher: AnyPublisher<String, Never>) -> AnyPublisher<FieldState, Never>
}



extension Validatable {
    func isEmpty(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.isEmpty })
            .eraseToAnyPublisher()
    }
    
    func isTooShort(publisher: AnyPublisher<String, Never>, count: Int) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.count < count })
            .eraseToAnyPublisher()
    }
    
    func hasNumbers(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.hasNumbers() })
            .eraseToAnyPublisher()
    }
    
    func isTooLong(publisher: AnyPublisher<String, Never>, count: Int) -> AnyPublisher<Bool, Never> {
        publisher
            .map({ $0.count > count })
            .eraseToAnyPublisher()
    }
    
    func isEmailAvailable(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .flatMap({ string -> AnyPublisher<Bool,Never> in
                let futureAsyncUsername = Future<Bool, Error> { promise in
                    AuthService.shared.isAvailable(string, inField: "email") { canUse, error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            switch canUse {
                            case true:
                                promise(.success(true))
                            case false:
                                promise(.success(false))
                            }
                        }
                    }
                }
                    .replaceError(with: false)
                    .eraseToAnyPublisher()
                return futureAsyncUsername
            }).eraseToAnyPublisher()
    }

    func isUsernameAvailable(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .flatMap({ string -> AnyPublisher<Bool,Never> in
                let futureAsyncUsername = Future<Bool, Error> { promise in
                    AuthService.shared.isAvailable(string, inField: "username") { canUse, error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            switch canUse {
                            case true:
                                promise(.success(true))
                            case false:
                                promise(.success(false))
                            }
                        }
                    }
                }
                    .replaceError(with: false)
                    .eraseToAnyPublisher()
                return futureAsyncUsername
            }).eraseToAnyPublisher()
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

//MARK: - Exapmle to use flat map
//let futureAsyncPublisher = Future<Bool, Error> { promise in
//    CNContactStore().requestAccess(for: .contacts) { grantedAccess, err in
//        // err is an optional
//        if let err = err {
//            return promise(.failure(err))
//        }
//        return promise(.success(grantedAccess))
//    }
//}.eraseToAnyPublisher()
//
//let futureAsyncUsername = Future<Bool, Error> { promise in
//    AuthService.shared.canUseNickname("dsads") { canUse, error in
//        if let error = error {
//            promise(.failure(error))
//        } else {
//            switch canUse {
//            case true:
//                promise(.success(true))
//            case false:
//                promise(.success(false))
//            }
//        }
//    }
//}.eraseToAnyPublisher()
