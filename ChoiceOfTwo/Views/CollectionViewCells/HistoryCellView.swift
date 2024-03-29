//
//  HistoryCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import UIKit


protocol HistoryCellDelegate {
    
    func matchTapped(match: Match)
}

class HistoryCellView: UICollectionViewCell {
    
    //MARK: - Variables
    private(set) var match: Match!
    var delegate: HistoryCellDelegate?
    
    private var skipped: [Anime] = []
    private var matched: [Anime] = []
    
    //MARK: - UI Components
    private let content: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.layer.borderColor = UIColor.mainPurple.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    private let playedWithHeader: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 17, type: .regular)
        label.textColor = .mainPurple
        label.text = "Played with"
        //        label.backgroundColor = .orange
        label.backgroundColor = .white
        return label
    }()
    private let profileImageButton = CustomCircleButton(customImage: "Profile")
    private let playedWithName: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 14, type: .regular)
        label.textColor = .mainPurple
        label.text = "Liard72"
        return label
    }()
    
    private let genresHeader: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 17, type: .regular)
        label.textColor = .mainPurple
        label.text = "Genres"
        return label
    }()
    
    private let genresCount: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 14, type: .regular)
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.text = "0"
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private let formatsHeader: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 17, type: .regular)
        label.textColor = .mainPurple
        label.text = "Formats"
        return label
    }()
    
    private let formatsCount: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 14, type: .regular)
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.text = "0"
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private let skippedHeader: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 17, type: .regular)
        label.textColor = .mainPurple
        label.text = "Skipped"
        return label
    }()
    private let skippedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.backgroundColor = .white
        collectionV.register(AnimeCardCellView.self, forCellWithReuseIdentifier: "Cell")
        return collectionV
    }()
    private let matchedHeader: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 17, type: .regular)
        label.textColor = .mainPurple
        label.text = "Matched"
        return label
    }()
    
    private let matchedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.backgroundColor = .white
        collectionV.register(AnimeCardCellView.self, forCellWithReuseIdentifier: "Cell")
        return collectionV
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        matchedCollectionView.delegate = self
        matchedCollectionView.dataSource = self
        skippedCollectionView.delegate = self
        skippedCollectionView.dataSource = self
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(skippedCollectionView)
        skippedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(playedWithHeader)
        playedWithHeader.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(playedWithName)
        playedWithName.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(genresHeader)
        genresHeader.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(genresCount)
        genresCount.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(formatsHeader)
        formatsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(formatsCount)
        formatsCount.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(skippedHeader)
        skippedHeader.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(matchedHeader)
        matchedHeader.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(matchedCollectionView)
        matchedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //        content.addSubview(matchedCollectionView)
        //        matchedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: self.topAnchor),
            content.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            playedWithHeader.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            playedWithHeader.topAnchor.constraint(equalTo: content.topAnchor, constant: 20),
            playedWithHeader.heightAnchor.constraint(equalToConstant: 15),
            //            playedWithHeader.widthAnchor.constraint(equalToConstant: 150),
            playedWithHeader.widthAnchor.constraint(equalToConstant: 130),
            
            profileImageButton.topAnchor.constraint(equalTo: playedWithHeader.bottomAnchor, constant: 5),
            profileImageButton.leadingAnchor.constraint(equalTo: playedWithHeader.leadingAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: 40),
            profileImageButton.widthAnchor.constraint(equalToConstant: 40),
            
            playedWithName.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor),
            playedWithName.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 5),
            playedWithName.heightAnchor.constraint(equalToConstant: 50),
            playedWithName.trailingAnchor.constraint(equalTo: playedWithHeader.trailingAnchor),
            
            genresHeader.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            genresHeader.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 10),
            genresHeader.heightAnchor.constraint(equalToConstant: 15),
            genresHeader.widthAnchor.constraint(equalToConstant: 150),
            
            genresCount.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            genresCount.topAnchor.constraint(equalTo: genresHeader.bottomAnchor, constant: 10),
            genresCount.heightAnchor.constraint(equalToConstant: 30),
            genresCount.widthAnchor.constraint(equalToConstant: 80),
            
            
            formatsHeader.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            formatsHeader.topAnchor.constraint(equalTo: genresCount.bottomAnchor, constant: 10),
            formatsHeader.heightAnchor.constraint(equalToConstant: 15),
            formatsHeader.widthAnchor.constraint(equalToConstant: 150),
            
            formatsCount.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            formatsCount.topAnchor.constraint(equalTo: formatsHeader.bottomAnchor, constant: 10),
            formatsCount.heightAnchor.constraint(equalToConstant: 30),
            formatsCount.widthAnchor.constraint(equalToConstant: 80),
            
            matchedHeader.leadingAnchor.constraint(equalTo: playedWithHeader.trailingAnchor, constant: 20),
            matchedHeader.topAnchor.constraint(equalTo: content.topAnchor, constant: 15),
            matchedHeader.heightAnchor.constraint(equalToConstant: 15),
            
            matchedCollectionView.topAnchor.constraint(equalTo: matchedHeader.bottomAnchor, constant: 5),
            matchedCollectionView.leadingAnchor.constraint(equalTo: matchedHeader.leadingAnchor),
            matchedCollectionView.widthAnchor.constraint(equalToConstant: 170),
            matchedCollectionView.heightAnchor.constraint(equalToConstant: 90),
            
            skippedHeader.leadingAnchor.constraint(equalTo: playedWithHeader.trailingAnchor, constant: 15),
            skippedHeader.topAnchor.constraint(equalTo: matchedCollectionView.bottomAnchor, constant: 10),
            skippedHeader.heightAnchor.constraint(equalToConstant: 15),
            
            skippedCollectionView.topAnchor.constraint(equalTo: skippedHeader.bottomAnchor, constant: 5),
            skippedCollectionView.leadingAnchor.constraint(equalTo: skippedHeader.leadingAnchor),
            skippedCollectionView.widthAnchor.constraint(equalToConstant: 170),
            skippedCollectionView.heightAnchor.constraint(equalToConstant: 90),
            
            
            
        ])
    }
    
    //MARK: - Configure
    public func configure(with match: Match) {
        self.match = match
        self.matched = match.matched
        self.matchedCollectionView.reloadData()
        self.skipped = match.skipped
        self.skippedCollectionView.reloadData()
        self.genresCount.text = match.genres.count == 0 ? "All" : String(match.genres.count)
        self.formatsCount.text = match.formats.count == 0 ? "All" : String(match.formats.count)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Selectors
    @objc private func tapped() {
        delegate?.matchTapped(match: self.match)
    }
}

extension HistoryCellView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == matchedCollectionView {
            if matched.count > 5 {
                return 5
            } else {
                return matched.count
            }
        } else {
            if skipped.count > 5 {
                return 5
            } else {
                return skipped.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? AnimeCardCellView else {
            fatalError("Failed to dequeue AnimeCardCellView")
        }
        
        if collectionView == matchedCollectionView {
            cell.configure(withImageString: matched[indexPath.row].coverImage?.extraLarge)
            return cell
        } else {
            cell.configure(withImageString: skipped[indexPath.row].coverImage?.extraLarge)
            return cell
        }
    }
}
