//
//  TagView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import UIKit

class CustomTagView: UIView {
    
    //MARK: - Variables
    public var selectChanged: ((CustomTagView) ->())?
    public var enumType: StringRepresentable!
    public var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    public var selected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.selected {
                    UIView.animate(withDuration: 0.2) {
                        self.label.backgroundColor = .mainPurple
                        self.label.textColor = .white
                        self.label.layer.cornerRadius = 10
                    }
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.label.backgroundColor = .white
                        self.label.textColor = .mainPurple
                        self.label.layer.cornerRadius = 10
                    }
                }
            }
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
         label.clipsToBounds = true
        return label
    }()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(gesture)
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
    
    @objc private func tapped() {
        selectChanged?(self)
    }
}
