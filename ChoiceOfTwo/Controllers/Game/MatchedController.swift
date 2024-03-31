//
//  MatchedController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 24/03/2024.
//

import UIKit

class MatchedController: UIViewController, MatchedAnimeCellProtocol {
    
    //MARK: - Variables
    var vm: MatchedVM!
    
    //MARK: - UI Components
    let backButton = CustomCircleButton(rotate: 1, stroke: true)
    let matchedHeaderLabel = CustomSectionHeaderView(headerName: "Matched")
    let matchedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//        collectionV.backgroundColor = .mainRed
        collectionV.backgroundColor = .white
        collectionV.register(MatchedAnimeCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionV
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.view.backgroundColor = .white
        matchedCollectionView.delegate = self
        matchedCollectionView.dataSource = self
        
        vm.onMatchedChanges = {
            self.matchedCollectionView.reloadData()
        }
        
        backButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(matchedHeaderLabel)
        matchedHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(matchedCollectionView)
        matchedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.matchedHeaderLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 10),
            self.matchedHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.matchedHeaderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            self.matchedCollectionView.topAnchor.constraint(equalTo: self.matchedHeaderLabel.bottomAnchor, constant: 20),
            self.matchedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.matchedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.matchedCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    //MARK: - Selectors
    @objc private func dismissButtonTapped() {
        vm.dimiss()
    }
    
    //MARK: - Delegate
    func didTapCell(with anime: Anime) {
        vm.goToDetail(anime: anime)
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
