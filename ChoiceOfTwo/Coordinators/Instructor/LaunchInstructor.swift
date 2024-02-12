//
//  LaunchInstructor.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import FirebaseAuth


fileprivate var isAuthorized = false

enum LaunchInstructor {
    case auth
    case home
    
    static func configure(isAuthorized: Bool = false) -> LaunchInstructor {
        if Auth.auth().currentUser != nil {
            return .home
        } else {
            return .auth
        }
//        if isAuthorized {
//            return .home
//        } else {
//            return .auth
//        }
    }
}

