//
//  CustomErrorLabel.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 13/02/2024.
//

import UIKit

class CustomErrorLabel: UIView {
    
    
    //MARK: - Varibales
    private var activeErrorConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(activeErrorConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(activeErrorConstraints)
        }
    }
    
    //MARK: UI Components
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.textColor = .white
        label.font = .nunitoFont(size: 18, type: .medium)
        label.alpha = 0.0
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
      return label
    }()
    
    //MARK: Lifecycle
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        self.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 30),
            
        ])
        
        activeErrorConstraints = [errorLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 20)]
    }
    
    
    
    public func configure(text: String) {
        self.errorLabel.text = text
    }
    
    public func showError() {
        
        
        UIView.animate(withDuration: 0.2) {
            self.activeErrorConstraints = [
                self.errorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
            
            self.layoutIfNeeded()
        }
    }
}


