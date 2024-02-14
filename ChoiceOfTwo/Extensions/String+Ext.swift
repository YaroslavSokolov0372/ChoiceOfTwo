//
//  String+Ext.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/02/2024.
//

import Foundation


extension String {
    func hasNumbers() -> Bool {
        //        return self.range(
        //            of: "^[0-9]*$", // 1
        //            options: .regularExpression) != nil
        return stringFulfillsRegex(regex: ".*[0-9].*")
    }
    
    func hasSpecialCharacters() -> Bool {
//        return self.range(
//            of: ".*[^A-Za-z0-9].*", // 1
//            options: .regularExpression) != nil
        return stringFulfillsRegex(regex: ".*[^A-Za-z0-9].*") // ^ means not
    }
    
    func isValidEmail() -> Bool {
        return stringFulfillsRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    private func stringFulfillsRegex(regex: String) -> Bool {
        let textTest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard textTest.evaluate(with: self) else {
            return false
        }
        return true
    }
    

}
