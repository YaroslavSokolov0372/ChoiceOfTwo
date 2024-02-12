//
//  EntryViewModel.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import Foundation


class EntryVM {
    
    weak var coordinator: EntryCoordinator!
    
    func goToLogin() {
        coordinator.login()
    }
    
    func goToRegister() {
        coordinator.register()
    }
}
