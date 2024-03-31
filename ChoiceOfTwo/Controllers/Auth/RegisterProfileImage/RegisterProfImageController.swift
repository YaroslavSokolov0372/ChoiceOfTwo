//
//  RegisterProfImageController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 01/03/2024.
//

import UIKit

class RegisterProfImageController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Variables
    var vm: RegisterProfImageVM!
    
    //MARK: - UI Components
    private let backButton = CustomCircleButton(rotate: 1, stroke: true)
//    private let imageButton = CustomCircleButton(customImage: "Profile", resized: CGSize(width: 120, height: 120))
    private let circleImage: UIImageView = {
      let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "Profile")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 100
        iv.alpha = 1.0
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.text = "Choose Profile Image"
        label.textAlignment = .center
        label.font = .nunitoFont(size: 26, type: .bold)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Click on button to choose an image"
        label.textAlignment = .center
        label.font = .nunitoFont(size: 16, type: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    private let skipButton = CustomButton(text: "Skip", type: .medium, strokeColor: .mainPurple)
    private let continueButton = CustomButton(text: "Continue", type: .medium, strokeColor: .mainPurple)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.backgroundColor = .white
        
        //        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageButtonTapped))
        circleImage.addGestureRecognizer(gesture)
    }
    
    
    
    
    
    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(imageButton)
//        imageButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(circleImage)
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            
//            imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageButton.widthAnchor.constraint(equalToConstant: 100),
//            imageButton.heightAnchor.constraint(equalToConstant: 100),
//            imageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -195),
            
            
            circleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleImage.widthAnchor.constraint(equalToConstant: 200),
            circleImage.heightAnchor.constraint(equalToConstant: 200),
            circleImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -195),
            
//            titleLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: circleImage.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skipButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40),
            skipButton.centerXAnchor.constraint(equalTo: subTitleLabel.centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            skipButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            continueButton.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 22),
            continueButton.centerXAnchor.constraint(equalTo: skipButton.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    func setupImage(image: UIImage?) {
        print("Image size -", image?.size)
        circleImage.image = image
        circleImage.alpha = 1.0
    }
    
    
    //MARK: - Selectors
    @objc private func imageButtonTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func skipButtonTapped() {
//        vm.goToHomePage()
    }
    
    @objc private func continueButtonTapped() {
    }
    
    @objc private func backButtonTapped() {
        vm.dismiss()
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }

}



