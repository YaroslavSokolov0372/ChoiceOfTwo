//
//  GameSetupControllerViewController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import UIKit

class SetupGameController: UIViewController, CustomTagsViewDelegate {
    
    
    
    //MARK: - Variables
    var vm: SetupGameVM!
    
    //MARK: - UI Components
    let readyButton = CustomButton(text: "Ready", type: .medium, backgroundColor: .mainLightGray)
    let backButton = CustomCircleButton(rotate: 1, stroke: true, cornerRadius: 25)
    let genresHeader = CustomSectionHeaderView(headerName: "Choose genres")
    let proposedGenres: CustomTagsView = {
        let tagsView = CustomTagsView()
        
        tagsView.numberOfRows = (Genre.allCases.count / 4)
        
        
        //        var genreTags: [String] = []
        //        Genre.allCases.forEach { genre in
        //            genreTags.append(genre.rawValue)
        //        }
        //        tagsView.tags = genreTags
        tagsView.tags = Genre.allCases
        
        return tagsView
    }()
    let seasonsHeader = CustomSectionHeaderView(headerName: "Choose Season")
    let proposedSeasons: CustomTagsView = {
        let tagsView = CustomTagsView()
        tagsView.numberOfRows = 0
        tagsView.tags = Season.allCases
        return tagsView
    }()
    let formatHeader = CustomSectionHeaderView(headerName: "Choose Format")
    let proposedFormats: CustomTagsView = {
        let tagsView = CustomTagsView()
        tagsView.numberOfRows = (Format.allCases.count / 4) + 1
        tagsView.tags = Format.allCases
        return tagsView
    }()
    let playersReady: UILabel = {
        let label = UILabel()
        label.text = "0/2"
        label.textColor = .mainPurple
        label.font = .nunitoFont(size: 14, type: .medium)
        return label
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        proposedGenres.delegate = self
        proposedFormats.delegate = self
        proposedSeasons.delegate = self
        setupUI()
        backButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        
        vm.onGenresChanges = { genres in
            for tv in self.proposedGenres.tagViews  {
                if genres.contains(tv.enumType.rawValue) {
                    tv.selected = true
                } else {
                    tv.selected = false
                }
            }
        }
        vm.onSeasonsChanges = { seasons in
            for tv in self.proposedSeasons.tagViews  {
                if seasons.contains(tv.enumType.rawValue) {
                    tv.selected = true
                } else {
                    tv.selected = false
                }
            }
        }
        vm.onFormatsChanges = { formats in
            for tv in self.proposedFormats.tagViews  {
                if formats.contains(tv.enumType.rawValue) {
                    tv.selected = true
                } else {
                    tv.selected = false
                }
            }
        }
        
        vm.onPlayersReadyChanges = { players in
            
            var ready = 0
            players.forEach { player in
                if player.value == true {
                    ready += 1
                }
            }
            UIView.animate(withDuration: 0.2) {
                self.playersReady.text = "\(ready)/2"
            }
            
            if ready == 2 {
                self.vm.goCardGame()
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        vm.removePlayerCountListener()
        vm.removeGameInfoListener()
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
        
        self.view.addSubview(playersReady)
        playersReady.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.readyButton.heightAnchor.constraint(equalToConstant: 50),
            self.readyButton.widthAnchor.constraint(equalToConstant: 130),
            self.readyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.readyButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10),
            
            self.playersReady.trailingAnchor.constraint(equalTo: self.readyButton.leadingAnchor, constant: -15),
            self.playersReady.bottomAnchor.constraint(equalTo: self.readyButton.bottomAnchor, constant: -5),
            
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
            self.proposedFormats.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    
    //MARK: - Selectors
    @objc private func dismissButtonTapped() {
        vm.exitTheGame()
    }
    
    @objc private func readyButtonTapped() {
        vm.changePlayersReadyState() { isReady in
            if isReady {
                UIView.animate(withDuration: 0.2) {
                    self.readyButton.backgroundColor = .mainPurple
                    self.readyButton.setTitleColor(.white, for: .normal)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.readyButton.backgroundColor = .mainLightGray
                    self.readyButton.setTitleColor(.mainPurple, for: .normal)
                }
            }
        }
    }
    
    //MARK: - Delegates
    func customTagsView(_ customTagsView: CustomTagsView, enumType: StringRepresentable, didSelectItemAt index: Int) {
        
        print(enumType)
        if enumType is Genre {
            print(enumType.rawValue)
            self.vm.preformGenresChanges(enumType as! Genre)
        }
        if enumType is Season {
            print("I am in seasons")
            self.vm.performSeasonChanges(enumType as! Season)
        }
        
        if enumType is Format {
            print("I am in formats")
            self.vm.performFormatChanges(enumType as! Format)
        }
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
