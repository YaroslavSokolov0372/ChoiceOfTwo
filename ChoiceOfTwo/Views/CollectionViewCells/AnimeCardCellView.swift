//
//  AnimeCardCellView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 29/03/2024.
//

import UIKit

class AnimeCardCellView: UICollectionViewCell {
    
    
    //MARK: - UI Components
    let imageView: UIImageView = {
     let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    public func configure(withImageString: String?) {
        self.imageView.setImageFromStringrURL(stringUrl: withImageString ?? "")
    }
}
