//
//  RegisterProfImage+Extension.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 01/03/2024.
//

import Foundation
import UIKit

extension RegisterProfImageController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true)
        
        self.vm.goToCropImage(image: image)
    }
}
