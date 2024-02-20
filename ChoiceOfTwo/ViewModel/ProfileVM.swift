//
//  ProfileVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 18/02/2024.
//

import Foundation
import UIKit

class ProfileVM {
    
     weak var coordinator: ProfileCoordinator!
     
     
    func dismiss() {
        coordinator.dismissScreen()
    }
}
