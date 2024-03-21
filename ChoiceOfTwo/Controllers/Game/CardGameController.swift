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
    
    var colors: [UIColor] = [.black, .purple, .green, .blue, .mainPurple, .red]
    
    
    //MARK: UI Components
    let finishButton = CustomButton(text: "Finish", type: .medium, backgroundColor: .white)
    let historyButton = CustomButton(text: "History", type: .medium, backgroundColor: .white)
    let stackView = StackViewContainer()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stackView.dataSource = self
        setupUI()
        vm.onAnimeListChange = {
            self.stackView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vm.fetchAnimes()
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(historyButton)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            finishButton.widthAnchor.constraint(equalToConstant: 80),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
            
            historyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            historyButton.widthAnchor.constraint(equalToConstant: 80),
            historyButton.heightAnchor.constraint(equalToConstant: 50),
            
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: finishButton.bottomAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalToConstant: 350),
            stackView.heightAnchor.constraint(equalToConstant: 500),
        ])
    }
}

extension CardGameController: SwipeCardDataSource {
        
    func numberOfCardsToShow() -> Int {
        vm.animeList.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.configure(with: vm.animeList[index])
        return card
    }
    
    func cardInfo(at index: Int) -> SwipeCardInfoView {
        let cardInfoView = SwipeCardInfoView()
        cardInfoView.configureWith(anime: vm.animeList[index])
        return cardInfoView
    }
    
    func emptyView() -> UIView? {
        nil
    }
}
