//
//  RegisterVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import Foundation
import Combine

class RegisterVM  {
    
    weak var coordinator: RegisterCoordinator!
    
    @Published var email = TextValidationPublished()
    @Published var password = TextValidationPublished()
    @Published var username = TextValidationPublished()
    
    var subscriptions = Set<AnyCancellable>()
    
    func dismiss() {
        coordinator.dismissScreen()
    }
}
