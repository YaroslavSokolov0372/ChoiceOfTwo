//
//  Font+Extension.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import Foundation
import UIKit

extension UIFont {
    
    enum NunitoFont {
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case regular
        case semiBold
    }
    
    static func nunitoFont(size: CGFloat, type: NunitoFont) -> UIFont? {
        switch type {
        case .bold:
            return UIFont(name: "Nunito-Bold", size: size)
        case .extraBold:
            return UIFont(name: "Nunito-ExtraBold", size: size)
        case .extraLight:
            return UIFont(name: "Nunito-ExtraLight", size: size)
        case .light:
            return UIFont(name: "Nunito-Light", size: size)
        case .medium:
            return UIFont(name: "Nunito-Medium", size: size)
        case .regular:
            return UIFont(name: "Nunito-Regular", size: size)
        case .semiBold:
            return UIFont(name: "Nunito-SemiBold", size: size)
        }
    }
}
