//
//  UINavigationController+Extension.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 01/04/2024.
//

import Foundation
import UIKit

extension UINavigationController {
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
}
