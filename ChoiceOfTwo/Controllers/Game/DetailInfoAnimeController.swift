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
            self.contentView.isHidden = self.viewsAreHidden
            self.scrollView.isHidden = self.viewsAreHidden
            self.animeDescription.isHidden = self.viewsAreHidden
            self.sideInfoView.isHidden = self.viewsAreHidden
            self.view.backgroundColor = self.viewsAreHidden ? .clear : .white
        }
    }
    
    //MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.backgroundColor = .white
        scrollV.showsVerticalScrollIndicator = false
        return scrollV
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var activeContentViewConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeContentViewConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeContentViewConstraints)
        }
    }
    
    let dismissButton = CustomCircleButton(
        customImage: "Plus",
        rotate: 4,
        resized: CGSize(width: 20, height: 20),
        imageColor: .mainPurple,
        stroke: true,
        cornerRadius: 20
    )
    
    let imageV: UIImageView = {
    let iv = UIImageView()
    iv.layer.masksToBounds = true
    iv.contentMode = .scaleAspectFill
    iv.layer.cornerRadius = 30
    return iv
}()
    
    private let animeName: UILabel = {
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
    
    private let animeDescription: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textColor = .mainPurple
            label.textAlignment = .left
            label.font = .nunitoFont(size: 17, type: .regular)
            return label
        }()
    
    private var activeAnimeDescriptionConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeAnimeDescriptionConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeAnimeDescriptionConstraints)
        }
    }
    
    private let sideInfoView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainPurple.cgColor
        view.layer.cornerRadius = 15
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
    
    private let formatHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Format"
        label.textColor = .mainPurple
        label.font = .nunitoFont(size: 17, type: .bold)
        return label
    }()
    
    private let format: UILabel = {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        imageV.setImageFromStringrURL(stringUrl: vm.anime.coverImage?.extraLarge ?? "")
        animeName.text = vm.anime.title
        
        if let episodes = vm.anime.episodes {
            self.episodes.text = String(describing: episodes)
        } else {
            self.episodes.text = "-"
        }
        
        if let meanScrore = vm.anime.meanScrore {
            self.meanScore.text = String(describing: meanScrore) + "%"
        } else {
            self.meanScore.text = "-"
        }
        
        if let format = vm.anime.format {
            self.format.text = format
        } else {
            self.format.text = "-"
        }
        
        animeDescription.text = vm.anime.description?.prepareHTMLDescription()
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let animeNameTextHeight = self.animeName.text!.height(constraintedWidth: self.view.frame.width - 30, font: UIFont.nunitoFont(size: 21, type: .bold)!)
        
        self.activeAnimeNameConstraints = [
            self.animeName.heightAnchor.constraint(equalToConstant: animeNameTextHeight),
        ]
        
        var height: CGFloat
        let lastView = self.animeDescription
        let lastViewYPos = lastView.frame.origin.y
        let lastViewHeight = lastView.frame.size.height
        
        // sanity check on these
//        print(lastViewYPos)
//        print(lastViewHeight)
        
        height = lastViewYPos + lastViewHeight /*- 20*/
        
//        print("setting scroll height: \(height)")
        
        self.activeContentViewConstraints = [
            self.contentView.heightAnchor.constraint(equalToConstant: height)
        ]
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageV)
        imageV.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(animeName)
        animeName.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(animeDescription)
        animeDescription.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(sideInfoView)
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
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageV.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
            imageV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageV.heightAnchor.constraint(equalToConstant: 400),
            imageV.widthAnchor.constraint(equalToConstant: 275),
            
            dismissButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dismissButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            
            animeName.topAnchor.constraint(equalTo: imageV.bottomAnchor, constant: 15),
            animeName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            animeName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            sideInfoView.topAnchor.constraint(equalTo: animeName.bottomAnchor, constant: 15),
            sideInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            sideInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            sideInfoView.heightAnchor.constraint(equalToConstant: 140),
            
            episodesHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            episodesHeader.heightAnchor.constraint(equalToConstant: 30),
            episodesHeader.leadingAnchor.constraint(equalTo: sideInfoView.leadingAnchor, constant: 10),
            episodesHeader.widthAnchor.constraint(equalToConstant: 115),
            
            episodes.topAnchor.constraint(equalTo: self.episodesHeader.bottomAnchor, constant: 10),
            episodes.widthAnchor.constraint(equalToConstant: 60),
            episodes.centerXAnchor.constraint(equalTo: self.episodesHeader.centerXAnchor),
            episodes.heightAnchor.constraint(equalToConstant: 60),
            
            meanScoreHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            meanScoreHeader.heightAnchor.constraint(equalToConstant: 30),
            meanScoreHeader.leadingAnchor.constraint(equalTo: self.episodesHeader.trailingAnchor),
            meanScoreHeader.widthAnchor.constraint(equalToConstant: 115),
            
            meanScore.topAnchor.constraint(equalTo: self.meanScoreHeader.bottomAnchor, constant: 10),
            meanScore.widthAnchor.constraint(equalToConstant: 60),
            meanScore.centerXAnchor.constraint(equalTo: meanScoreHeader.centerXAnchor),
            meanScore.heightAnchor.constraint(equalToConstant: 60),
            
            formatHeader.topAnchor.constraint(equalTo: sideInfoView.topAnchor, constant: 10),
            formatHeader.heightAnchor.constraint(equalToConstant: 30),
            formatHeader.leadingAnchor.constraint(equalTo: self.meanScoreHeader.trailingAnchor),
            formatHeader.widthAnchor.constraint(equalToConstant: 115),
            
            
            format.topAnchor.constraint(equalTo: self.formatHeader.bottomAnchor, constant: 10),
            format.widthAnchor.constraint(equalToConstant: 60),
            format.centerXAnchor.constraint(equalTo: self.formatHeader.centerXAnchor),
            format.heightAnchor.constraint(equalToConstant: 60),
            
            
            animeDescription.topAnchor.constraint(equalTo: sideInfoView.bottomAnchor, constant: 15),
            animeDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            animeDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        ])
        
        self.activeAnimeNameConstraints = [
            self.animeName.heightAnchor.constraint(equalToConstant: 20),
        ]
        
        self.activeContentViewConstraints = [
            self.contentView.heightAnchor.constraint(equalToConstant: 500)
        ]
    }
    
    
    //MARK: - Selectors
    @objc private func dismissButtonTapped() {
        if vm.isSheet {
            vm.dismissAsSheet()
        } else {
            vm.dismiss()
        }
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
