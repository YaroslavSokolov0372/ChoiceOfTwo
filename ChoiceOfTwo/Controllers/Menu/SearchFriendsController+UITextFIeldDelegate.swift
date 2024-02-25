//
//  SearchFriendsController+UITextFIeldDelegate.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 21/02/2024.
//

import Foundation
import UIKit

extension SearchFriendsController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if currentPage == 1 {
            listenForSearchTextChanges()
            requestOnSearchNewUserBinding()
        } else if currentPage == 2 {
            listenForSearchTextChanges()
            requestOnSearchInvUserBinding()
        }
    }
}
