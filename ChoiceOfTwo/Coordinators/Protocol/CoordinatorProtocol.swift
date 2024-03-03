//
//  CoordinatorProtocol.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 11/02/2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    func start(image: UIImage?)
    
}


extension Coordinator {
    func start(image: UIImage? = nil) {
        
    }
}
