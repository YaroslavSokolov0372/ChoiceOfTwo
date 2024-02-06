//
//  CoordinatorProtocol.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import Foundation
import UIKit

protocol Coordinator {
    
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    func start()
}
