//
//  MatchedAnimeCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 27/03/2024.
//

import UIKit

protocol MatchedAnimeCellProtocol {
    func didTapCell(with anime: Anime)
}


class MatchedAnimeCell: UICollectionViewCell {
    
    //MARK: - Variables
    var anime: Anime!
    var delegate: MatchedAnimeCellProtocol?
    
    //MARK: - UI Components
    private let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    private let animeName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .mainPurple
        label.numberOfLines = 0
        label.font = .nunitoFont(size: 18, type: .regular)
        return label
    }()
    private let sideInfoView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainPurple.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let episodesHeader: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.text = "Episodes"
        label.font = .nunitoFont(size: 13, type: .bold)
        return label
    }()
    private let episodes: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.font = .nunitoFont(size: 10, type: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    private let meanScoreHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Mean Score"
        label.textColor = .mainPurple
        label.font = .nunitoFont(size: 13, type: .bold)
        return label
    }()
    private let meanScore: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.font = .nunitoFont(size: 10, type: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    private let formatHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Format"
        label.textColor = .mainPurple
        label.font = .nunitoFont(size: 13, type: .bold)
        return label
    }()
    private let format: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.font = .nunitoFont(size: 9, type: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private var activeNameConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeNameConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeNameConstraints)
        }
    }
    
    
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupUI()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configure
    public func configure(with anime: Anime) {
        self.anime = anime
        
        self.coverImage.setImageFromStringrURL(stringUrl: anime.coverImage?.extraLarge ?? "")
        
        self.animeName.text = anime.title
        let textHeight = self.animeName.text!.height(constraintedWidth: self.frame.width - 140, font: UIFont.nunitoFont(size: 18, type: .regular)!)
        let numberOfRows = textHeight / 22
        
        
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
            self.format.text = format
        } else {
            self.format.text = "-"
        }
        
        if numberOfRows > 4 {
            self.activeNameConstraints = [
                self.animeName.heightAnchor.constraint(equalToConstant: 25 * 4),
            ]
            self.animeName.numberOfLines = 4
        } else {
            self.activeNameConstraints = [
                self.animeName.heightAnchor.constraint(equalToConstant: textHeight),
            ]
            self.animeName.numberOfLines = Int(numberOfRows)
        }
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.addSubview(coverImage)
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        sideInfoView.addSubview(format)
        format.translatesAutoresizingMaskIntoConstraints = false
        
        sideInfoView.addSubview(formatHeader)
        formatHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.coverImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.coverImage.heightAnchor.constraint(equalToConstant: 200),
            self.coverImage.widthAnchor.constraint(equalToConstant: 120),
            self.coverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            self.animeName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.animeName.leadingAnchor.constraint(equalTo: self.coverImage.trailingAnchor, constant: 10),
            self.animeName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
//            self.sideInfoView.topAnchor.constraint(equalTo: animeName.bottomAnchor, constant: 15),
            self.sideInfoView.bottomAnchor.constraint(equalTo: self.coverImage.bottomAnchor),
            self.sideInfoView.leadingAnchor.constraint(equalTo: self.coverImage.trailingAnchor, constant: 10),
            self.sideInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.sideInfoView.heightAnchor.constraint(equalToConstant: 80),
            
            self.episodesHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            self.episodesHeader.heightAnchor.constraint(equalToConstant: 15),
            self.episodesHeader.leadingAnchor.constraint(equalTo: sideInfoView.leadingAnchor, constant: 10),
            self.episodesHeader.widthAnchor.constraint(equalToConstant: 60),
            
            self.episodes.topAnchor.constraint(equalTo: self.episodesHeader.bottomAnchor, constant: 10),
            self.episodes.widthAnchor.constraint(equalToConstant: 30),
            self.episodes.centerXAnchor.constraint(equalTo: self.episodesHeader.centerXAnchor),
            self.episodes.heightAnchor.constraint(equalToConstant: 30),
            
            self.meanScoreHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            self.meanScoreHeader.heightAnchor.constraint(equalToConstant: 15),
            self.meanScoreHeader.leadingAnchor.constraint(equalTo: self.episodesHeader.trailingAnchor, constant: 10),
            self.meanScoreHeader.widthAnchor.constraint(equalToConstant: 80),
            
            
            self.meanScore.topAnchor.constraint(equalTo: self.meanScoreHeader.bottomAnchor, constant: 10),
            self.meanScore.widthAnchor.constraint(equalToConstant: 30),
            self.meanScore.centerXAnchor.constraint(equalTo: self.meanScoreHeader.centerXAnchor),
            self.meanScore.heightAnchor.constraint(equalToConstant: 30),
            
            self.formatHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            self.formatHeader.heightAnchor.constraint(equalToConstant: 15),
            self.formatHeader.leadingAnchor.constraint(equalTo: meanScoreHeader.trailingAnchor, constant: 10),
            self.formatHeader.widthAnchor.constraint(equalToConstant: 60),
            
            self.format.topAnchor.constraint(equalTo: self.formatHeader.bottomAnchor, constant: 10),
            self.format.widthAnchor.constraint(equalToConstant: 30),
            self.format.centerXAnchor.constraint(equalTo: self.formatHeader.centerXAnchor),
            self.format.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        self.activeNameConstraints = [
            self.animeName.heightAnchor.constraint(equalToConstant: 20),
        ]
    }
    
    //MARK: - Selectors
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapCell(with: anime)
    }
}
