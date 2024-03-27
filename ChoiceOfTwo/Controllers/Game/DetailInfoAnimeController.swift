//
//  DetailInfoAnimeController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/03/2024.
//

import UIKit

class DetailInfoAnimeController: UIViewController {
    
    //MARK: - Variables
    var vm: DetailInfoAnimeVM!
    
    var viewsAreHidden: Bool = false {
        didSet {
            self.dismissButton.isHidden = self.viewsAreHidden
            self.imageV.isHidden = self.viewsAreHidden
            self.animeName.isHidden = self.viewsAreHidden
            self.animeDescription.isHidden = self.viewsAreHidden
            self.view.backgroundColor = self.viewsAreHidden ? .clear : .white
        }
    }
    
    //MARK: - UI Components
    let imageV: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        return iv
    }()
    
    let dismissButton = CustomCircleButton(
        customImage: "Plus",
        rotate: 4,
        resized: CGSize(width: 20, height: 20),
        imageColor: .mainPurple,
        stroke: true,
        cornerRadius: 20
    )
    let animeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .mainPurple
        label.textAlignment = .left
        label.font = .nunitoFont(size: 21, type: .bold)
        return label
    }()
    private var activeAnimeNameConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeAnimeNameConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeAnimeNameConstraints)
        }
    }
    let animeDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .mainPurple
        label.textAlignment = .left
        label.font = .nunitoFont(size: 17, type: .regular)
        return label
    }()
    private var activeAnimeDescriptionConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeAnimeNameConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeAnimeNameConstraints)
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        imageV.setImageFromStringrURL(stringUrl: vm.anime.coverImage?.extraLarge ?? "")
        animeName.text = vm.anime.title
        animeDescription.text = vm.anime.description?.prepareHTMLDescription()
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(imageV)
        imageV.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animeName)
        animeName.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animeDescription)
        animeDescription.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            imageV.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            imageV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            imageV.heightAnchor.constraint(equalToConstant: 400),
            imageV.widthAnchor.constraint(equalToConstant: 275),
            
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dismissButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            
            animeName.topAnchor.constraint(equalTo: imageV.bottomAnchor, constant: 15),
            animeName.leadingAnchor.constraint(equalTo: imageV.leadingAnchor, constant: 15),
            animeName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            animeDescription.topAnchor.constraint(equalTo: animeName.bottomAnchor, constant: 15),
            animeDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            animeDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
        ])
        
        self.activeAnimeNameConstraints = [
            self.animeName.heightAnchor.constraint(equalToConstant: 20),
        ]
    }
    
    
    //MARK: - Selectors
    @objc private func dismissButtonTapped() {
        vm.dismiss()
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
