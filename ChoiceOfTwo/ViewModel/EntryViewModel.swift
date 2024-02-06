//
//  EntryViewModel.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 06/02/2024.
//

import Foundation


class EntryViewModel {
     var coordinator: AppCoordinator!
    
    func goToLogin() {
        coordinator.goToLoginPage()
    }
}
