//
//  MatchedController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 24/03/2024.
//

import UIKit

class MatchedController: UIViewController {
    
    //MARK: - Variables
    var vm: MatchedVM!
    
    //MARK: - UI Components
    let backButton = CustomCircleButton(rotate: 1, stroke: true)
    let matchedCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.register(MatchedAnimeCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionV
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        matchedCollectionView.delegate = self
        matchedCollectionView.dataSource = self
        setupUI()
        backButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        ])
    }
    
    //MARK: - Selectors
    @objc private func dismissButtonTapped() {
        vm.dimiss()
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
