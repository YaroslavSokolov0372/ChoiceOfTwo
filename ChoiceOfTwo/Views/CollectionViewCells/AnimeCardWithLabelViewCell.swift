//
//  AnimeCardWithLabelViewCell.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 31/03/2024.
//

import UIKit

protocol AnimeCardWithLabelPotocol {
    func didTapCell(with anime: Anime)
}

class AnimeCardWithLabelViewCell: UICollectionViewCell {
 
    
    //MARK: - Variabels
    var delegate: AnimeCardWithLabelPotocol?
    private var anime: Anime!
    private var activeNameConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeNameConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeNameConstraints)
        }
    }
    
    //MARK: UI Comonents
    private let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .nunitoFont(size: 14, type: .regular)
        label.text = ""
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.contentView.addSubview(coverImage)
        self.contentView.addSubview(name)
        
        self.coverImage.translatesAutoresizingMaskIntoConstraints = false
        self.name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.coverImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            self.coverImage.heightAnchor.constraint(equalToConstant: 240),
            self.coverImage.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.name.topAnchor.constraint(equalTo: self.coverImage.bottomAnchor, constant: 10),
            self.name.widthAnchor.constraint(equalTo: self.widthAnchor),
            
        ])
        
        self.activeNameConstraints = [
            self.name.heightAnchor.constraint(equalToConstant: 20),
        ]
    }
    
    //MARK: - Selectors
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapCell(with: anime)
    }
    
    //MARK: - Configure
    public func configure(with anime: Anime) {
        self.anime = anime
        self.coverImage.setImageFromStringrURL(stringUrl: anime.coverImage?.extraLarge ?? "")
        self.name.text = anime.title
        
        let textHeight = self.name.text!.height(constraintedWidth: self.frame.width, font: UIFont.nunitoFont(size: 14, type: .regular)!)
        let numberOfRows = textHeight / 14
        
        if numberOfRows > 4 {
            self.activeNameConstraints = [
                self.name.heightAnchor.constraint(equalToConstant: 14 * 4),
            ]
            self.name.numberOfLines = 4
        } else {
            self.activeNameConstraints = [
                self.name.heightAnchor.constraint(equalToConstant: textHeight),
            ]
            self.name.numberOfLines = Int(numberOfRows)
        }
    }
}
