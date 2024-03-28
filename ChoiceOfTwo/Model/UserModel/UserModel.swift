//
//  FriendModel.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation


struct User: Codable {
    
    let uid: String
    var email: String
    var username: String
    var keywordsForLookUp: [String] {
        self.username.generateStringSequence()
    }
}



