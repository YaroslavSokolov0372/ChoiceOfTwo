//
//  UIScrollView+Extension.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 25/02/2024.
//

import Foundation
import UIKit

extension UIScrollView {
   var currentPage: Int {
      return Int((self.contentOffset.x + (0.5 * self.frame.size.width)) / self.frame.width) + 1
   }
}
