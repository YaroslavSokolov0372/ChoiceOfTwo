//
//  SwipeCardInfo.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 21/03/2024.
//

import UIKit

class SwipeCardInfoView: UIView {
    
    //MARK: - UI Components
    
    
    private let animeName: UILabel = {
      let label = UILabel()
        label.textAlignment = .left
        label.textColor = .mainPurple
        label.numberOfLines = 3
        label.font = .nunitoFont(size: 20, type: .bold)
        return label
    }()
    private let sideInfoView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainPurple.cgColor
        view.layer.cornerRadius = 30
        return view
    }()
    private let episodesHeader: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.text = "Episodes"
        label.font = .nunitoFont(size: 17, type: .bold)
        return label
    }()
    private let episodes: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.font = .nunitoFont(size: 17, type: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 30
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    private let meanScoreHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Mean Score"
        label.textColor = .mainPurple
        label.font = .nunitoFont(size: 17, type: .bold)
        return label
    }()
    private let meanScore: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.font = .nunitoFont(size: 17, type: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 30
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    private let statusHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Status"
        label.textColor = .mainPurple
        label.font = .nunitoFont(size: 17, type: .bold)
        return label
    }()
    private let status: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.font = .nunitoFont(size: 17, type: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 30
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        clipsToBounds = true
        backgroundColor = .white
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.mainPurple.cgColor
//        layer.cornerRadius = 30
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.addSubview(animeName)
        animeName.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(sideInfoView)
        sideInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        sideInfoView.addSubview(episodes)
        episodes.translatesAutoresizingMaskIntoConstraints = false
        
        sideInfoView.addSubview(episodesHeader)
        episodesHeader.translatesAutoresizingMaskIntoConstraints = false
        
        sideInfoView.addSubview(meanScore)
        meanScore.translatesAutoresizingMaskIntoConstraints = false
        
        sideInfoView.addSubview(meanScoreHeader)
        meanScoreHeader.translatesAutoresizingMaskIntoConstraints = false
        
        sideInfoView.addSubview(status)
        status.translatesAutoresizingMaskIntoConstraints = false
        
        sideInfoView.addSubview(statusHeader)
        statusHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            animeName.topAnchor.constraint(equalTo: self.topAnchor/*, constant: 10*/),
            animeName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            animeName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            animeName.heightAnchor.constraint(equalToConstant: 65),
            
            sideInfoView.topAnchor.constraint(equalTo: animeName.bottomAnchor, constant: 15),
            sideInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sideInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sideInfoView.heightAnchor.constraint(equalToConstant: 140),
            
            episodesHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            episodesHeader.heightAnchor.constraint(equalToConstant: 30),
            episodesHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            episodesHeader.widthAnchor.constraint(equalToConstant: 115),
            
            
            episodes.topAnchor.constraint(equalTo: self.episodesHeader.bottomAnchor, constant: 10),
            episodes.widthAnchor.constraint(equalToConstant: 60),
//            episodes.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            episodes.centerXAnchor.constraint(equalTo: episodesHeader.centerXAnchor),
            episodes.heightAnchor.constraint(equalToConstant: 60),
            
            
            meanScoreHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            meanScoreHeader.heightAnchor.constraint(equalToConstant: 30),
            meanScoreHeader.leadingAnchor.constraint(equalTo: self.episodesHeader.trailingAnchor),
            meanScoreHeader.widthAnchor.constraint(equalToConstant: 115),
            
            
            meanScore.topAnchor.constraint(equalTo: self.meanScoreHeader.bottomAnchor, constant: 10),
            meanScore.widthAnchor.constraint(equalToConstant: 60),
            meanScore.centerXAnchor.constraint(equalTo: meanScoreHeader.centerXAnchor),
//            meanScore.leadingAnchor.constraint(equalTo: self.episodesHeader.leadingAnchor),
            meanScore.heightAnchor.constraint(equalToConstant: 60),
            
            statusHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            statusHeader.heightAnchor.constraint(equalToConstant: 30),
            statusHeader.leadingAnchor.constraint(equalTo: self.meanScoreHeader.trailingAnchor),
            statusHeader.widthAnchor.constraint(equalToConstant: 115),
            
            
            status.topAnchor.constraint(equalTo: self.statusHeader.bottomAnchor, constant: 10),
            status.widthAnchor.constraint(equalToConstant: 60),
//            status.leadingAnchor.constraint(equalTo: self.meanScoreHeader.leadingAnchor),
            status.centerXAnchor.constraint(equalTo: self.statusHeader.centerXAnchor),
            status.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    //MARK: - Configure
    func configureWith(anime: Anime) {
        
        self.animeName.text = anime.title!
        
        if let episodes = anime.episodes {
            self.episodes.text = String(describing: episodes)
        } else {
            self.episodes.text = "-"
        }
        
        if let meanScrore = anime.meanScrore {
            self.meanScore.text = String(describing: meanScrore) + "%"
        } else {
            self.meanScore.text = "-"
        }
        
        if let format = anime.format {
            self.status.text = format
        } else {
            self.status.text = "-"
        }
    }
}