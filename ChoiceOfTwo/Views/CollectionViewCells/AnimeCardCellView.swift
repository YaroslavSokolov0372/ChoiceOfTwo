//
//  AnimeCardCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/03/2024.
//

import UIKit
import SkeletonView

class AnimeCardCellView: UICollectionViewCell {
    
    
    //MARK: - UI Components
    let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = true
        imageV.backgroundColor = .mainLightGray
        imageV.layer.cornerRadius = 12
        return imageV
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.textAlignment = .center
        label.font = .nunitoFont(size: 12, type: .regular)
        label.text = "None"
        label.alpha = 0.0
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        self.emptyLabel.isSkeletonable = true
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func setupNone() {
        self.contentView.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
    
    //MARK: - Configure
    public func configure(withImageString: String?) {
        self.imageView.setImageFromStringrURL(stringUrl: withImageString ?? "")
    }
    
    public func configureAsNone() {
        setupNone()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.emptyLabel.alpha = 1.0
        }
    }
}
