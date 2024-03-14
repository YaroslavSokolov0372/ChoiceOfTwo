//
//  TagView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import UIKit

class CustomTagView: UIView {
    
    //MARK: - Variables
    
    public var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    
    
    //MARK: - UI Components
     let label: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.layer.borderColor = UIColor.mainPurple.cgColor
        label.font = .nunitoFont(size: 15, type: .regular)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        return label
    }()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI
    func setupUI(textSize: CGSize) {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: textSize.width + 23),
            self.heightAnchor.constraint(equalToConstant: textSize.height + 23),
            
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    //MARK: - Selector
    
//    @objc private func tapped() {
//        selected.toggle()
//
//    }
}
