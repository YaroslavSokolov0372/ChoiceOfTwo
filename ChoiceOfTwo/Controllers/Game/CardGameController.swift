//
//  CardGameController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/03/2024.
//

import UIKit



class CardGameController: UIViewController {
    
    
    //MARK: Variables
    var vm: CardGameVM!
    
    
    //MARK: UI Components
    private let cardContainerView = SwipeableCardViewContainer()
    private let card = SwipeableCardViewCard()
    let readyButton = CustomButton(text: "Ready", type: .medium, backgroundColor: .mainLightGray)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        self.view.addSubview(cardContainerView)
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            cardContainerView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            cardContainerView.heightAnchor.constraint(equalToConstant: 300),
            
            
            self.readyButton.heightAnchor.constraint(equalToConstant: 50),
            self.readyButton.widthAnchor.constraint(equalToConstant: 130),
            self.readyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.readyButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10),
        ])
    }
}
