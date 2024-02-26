//
//  ChooseProfPictureController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 25/02/2024.
//

import UIKit
import CropViewController
import TOCropViewController

class ChooseProfPictureController: UIViewController, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    private var vm = ChooseProfPictureVM()
    
    //MARK: - Variables
    private let profileImage = CustomCircleButton(customImage: "Profile", resized: CGSize(width: 130, height: 130))
    private let imageDescription: UILabel = {
      let label = UILabel()
        return label
    }()
    private let skipButton = CustomButton(text: "Skip", type: .medium, strokeColor: .mainPurple)
    
    //MARK: - UI Components
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        
//        profileImage.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        profileImage.addTarget(self, action: #selector(showCrop1), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageDescription)
        imageDescription.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 30),
            profileImage.widthAnchor.constraint(equalToConstant: 130),
            profileImage.heightAnchor.constraint(equalToConstant: 130),
            profileImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            imageDescription.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5),
            imageDescription.widthAnchor.constraint(equalToConstant: 130),
            
            skipButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 22),
            skipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            skipButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    //MARK: - Selectors
    @objc private func skipButtonTapped() {
        
    }
    
    @objc private func profileImageTapped() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func showCrop1() {
        let image = UIImage(named: "CropTest")!
        let vc = CropViewController(croppingStyle: .circular, image: image)
        vc.aspectRatioPreset = .presetOriginal
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonColor = .mainPurple
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.cancelButtonColor = .mainRed
        vc.view.backgroundColor = .white
        
        vc.delegate = self
        present(vc, animated: true)
        
//        let newVC = TOCropViewController()
    }
    
    
    func showCrop(_ image: UIImage) {
        let vc = CropViewController(croppingStyle: .circular, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonColor = .mainPurple
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        vc.cancelButtonColor = .mainRed
        vc.view.backgroundColor = .white
        
        vc.delegate = self
        present(vc, animated: true)
        
//        let newVC = TOCropViewController()
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("Did Crop")
    }
    
    
}


extension ChooseProfPictureController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true)
        
        showCrop(image)
    }
}
