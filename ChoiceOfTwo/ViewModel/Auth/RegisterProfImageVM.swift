//
//  RegisterProfImageVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 01/03/2024.
//

import Foundation
import UIKit


class RegisterProfImageVM {
    
    weak var coordinator: RegisterProfImageCoordinator!
    var image: UIImage?
    private let dbManager = DataBaseManager()
    
    func goToCropImage(image: UIImage) {
        coordinator.goToCropImage(image: image)
    }
    
    func dismiss() {
        coordinator.dismissScreen()
    }
    
    func goToHomePage() {
        coordinator.parent?.home()
    }
    
    func registerProfImage(image: UIImage, completion: @escaping () -> ()) {
        dbManager.writeProfImage(image: image) { success, error in
            if let error = error {
                print("Error while writing prof image", error)
            }
            if success {
                completion()
            }
        }
    }
}
