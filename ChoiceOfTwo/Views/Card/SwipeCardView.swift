//
//  SwipeCardView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 21/03/2024.
//

import UIKit

enum Direction {
    case left
    case right
}

class SwipeCardView: UIView {
    
    
    //MARK: - Variables
    var delegate: SwipeCardsDelegate?
    
    private let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 30

        return iv
    }()
    private let name: UILabel = {
        let label = UILabel()
        label.font = .nunitoFont(size: 20, type: .regular)
        label.textColor = .mainPurple
//        label.backgroundColor = .white
//        label.clipsToBounds = true
//        label.layer.borderColor = UIColor.mainPurple.cgColor
//        label.layer.borderWidth = 1
//        label.layer.cornerRadius = 12
        //        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        
        layer.masksToBounds = true
        clipsToBounds = true
//        backgroundColor = .mainLightGray
        layer.cornerRadius = 30
//        layer.cornerRadius = 30
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGestureRecognizer)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        self.addSubview(coverImage)
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        
//        self.addSubview(name)
//        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverImage.topAnchor.constraint(equalTo: self.topAnchor),
            coverImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            coverImage.heightAnchor.constraint(equalToConstant: 500),
            
//            name.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 10),
//            name.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            name.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            name.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
    }
    
    func configure(with anime: Anime) {
        self.coverImage.setImageFromStringrURL(stringUrl: anime.coverImage?.extraLarge ?? "")
        
        self.name.text = anime.title
        
    }
    
    //MARK: - Selectors
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let card = sender.view as! SwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)

        switch sender.state {
         case .ended:
             if (card.center.x) > 370 {
                 delegate?.swipeDidEnd(on: card, direction: .right)
                 UIView.animate(withDuration: 0.3) {
                     card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                     card.alpha = 0
                     self.layoutIfNeeded()
                 }
                 return
             }else if card.center.x < 30 {
                 delegate?.swipeDidEnd(on: card, direction: .left)
                 UIView.animate(withDuration: 0.3) {
                     card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                     card.alpha = 0
                     self.layoutIfNeeded()
                 }
                 return
             }
             UIView.animate(withDuration: 0.3) {
                 card.transform = .identity
                 card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                 self.layoutIfNeeded()
             }
         case .changed:
              let rotation = tan(point.x / (self.frame.width * 2.0))
             card.transform = CGAffineTransform(rotationAngle: rotation)

         default:
             break
         }
    }
}


protocol SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView, direction: Direction)
}
