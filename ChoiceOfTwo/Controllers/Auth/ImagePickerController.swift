//
//  ImagePickerController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import UIKit

class ImagePickerController: UIViewController {
    
    
    private let profileImage = CustomCircleButton(customImage: "Logout")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mainPurple
        profileImage.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        setupUI()
    }
    
    
    @objc private func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    private func setupUI() {
        
        self.view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.profileImage.heightAnchor.constraint(equalToConstant: 60),
            self.profileImage.widthAnchor.constraint(equalToConstant: 60),
            self.profileImage.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.profileImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
}
