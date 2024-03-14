//
//  GameSetupControllerViewController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import UIKit

class SetupGameController: UIViewController {
    
    //MARK: - Variables
    var vm = SetupGameVM()
    
    //MARK: - UI Components
    let readyButton = CustomButton(text: "Ready", type: .medium, backgroundColor: .mainLightGray)
    let backButton = CustomCircleButton(rotate: 1, stroke: true, cornerRadius: 25)
    let genresHeader = CustomSectionHeaderView(headerName: "Choose genres")
    let proposedGenres: CustomTagsView = {
        let tagsView = CustomTagsView()
        
            tagsView.numberOfRows = (Genre.allCases.count / 4)
        
        
        var genreTags: [String] = []
        Genre.allCases.forEach { genre in
            genreTags.append(genre.rawValue)
        }
        tagsView.tags = genreTags
        return tagsView
    }()
    let seasonsHeader = CustomSectionHeaderView(headerName: "Choose Season")
    let proposedSeasons: CustomTagsView = {
        let tagsView = CustomTagsView()
//        tagsView.numberOfRows = (Season.allCases.count / 4)
        tagsView.numberOfRows = 0
        var seasonTags: [String] = []
        Season.allCases.forEach { genre in
            seasonTags.append(genre.rawValue)
        }
        tagsView.tags = seasonTags
        return tagsView
    }()
    let formatHeader = CustomSectionHeaderView(headerName: "Choose Format")
    let proposedFormats: CustomTagsView = {
        let tagsView = CustomTagsView()
        tagsView.numberOfRows = (Format.allCases.count / 4) + 1
//        tagsView.numberOfRows = 0
        var seasonTags: [String] = []
        Format.allCases.forEach { genre in
            seasonTags.append(genre.rawValue)
        }
        tagsView.tags = seasonTags
        return tagsView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        backButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(genresHeader)
        genresHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(proposedGenres)
        proposedGenres.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(seasonsHeader)
        seasonsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(proposedSeasons)
        proposedSeasons.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(formatHeader)
        formatHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(proposedFormats)
        proposedFormats.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
//            self.readyButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10),
            self.readyButton.heightAnchor.constraint(equalToConstant: 50),
            self.readyButton.widthAnchor.constraint(equalToConstant: 130),
            self.readyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.readyButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10),
            
//            self.genresHeader.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.genresHeader.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            self.genresHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.genresHeader.heightAnchor.constraint(equalToConstant: 30),
            
            self.proposedGenres.topAnchor.constraint(equalTo: self.genresHeader.bottomAnchor, constant: 10),
            self.proposedGenres.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.proposedGenres.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.proposedGenres.heightAnchor.constraint(equalToConstant: (CGFloat((Genre.allCases.count) / 4) + 1) * 50),
            
            self.seasonsHeader.topAnchor.constraint(equalTo: proposedGenres.bottomAnchor, constant: 20),
            self.seasonsHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.seasonsHeader.heightAnchor.constraint(equalToConstant: 20),
            
            self.proposedSeasons.topAnchor.constraint(equalTo: seasonsHeader.bottomAnchor, constant: 10),
            self.proposedSeasons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.proposedSeasons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.proposedSeasons.heightAnchor.constraint(equalToConstant: (CGFloat((Season.allCases.count) / 4)) * 50),

            self.formatHeader.topAnchor.constraint(equalTo: proposedSeasons.bottomAnchor, constant: 20),
            self.formatHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.formatHeader.heightAnchor.constraint(equalToConstant: 20),
            
            self.proposedFormats.topAnchor.constraint(equalTo: formatHeader.bottomAnchor, constant: 10),
            self.proposedFormats.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.proposedFormats.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.proposedFormats.heightAnchor.constraint(equalToConstant: (CGFloat((Format.allCases.count) / 4)) * 50),
        ])
    }
    
    
    //MARK: - Selectors
    @objc private func dismissButtonTapped() {
        
    }
}
