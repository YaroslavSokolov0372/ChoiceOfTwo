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
    let finishButton = CustomButton(text: "Finish", type: .medium, backgroundColor: .white)
    let historyButton = CustomButton(text: "Mathed", type: .medium, backgroundColor: .white)
    let newMatchesPoint = NewMatchesPointView(backgroundColor: .mainPurple, cornerRadius: 8)
    let stackView = StackViewContainer()
    lazy var messageLabel = CustomAnimatedMessageLabel(frame: CGRect(
        x: (view.frame.width * 0.07),
        y: view.frame.maxY,
        width: (view.frame.width * 0.85),
        height: 65))
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stackView.dataSource = self
        stackView.delegate = self
        setupUI()
        historyButton.addTarget(self, action: #selector(matchedButtonTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        
        vm.onAnimeListChange = { numOfAni in
            
            if numOfAni != 0 {
                self.stackView.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if numOfAni == 0 {
                    self.messageLabel.configure(message: "No Results. Try to restard the game", strokeColor: .mainPurple)
                    self.messageLabel.playAnimation()
                }
            }
        }
        vm.onAnimeListError = { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.messageLabel.configure(message: "Failed to load Anime. Try to restart the game", strokeColor: .mainRed)
                self.messageLabel.playAnimation()
            }
        }
        vm.onMatchedChanged = {
            self.newMatchesPoint.visible = true
        }
        stackView.onZeroRemaining = {
            if self.vm.genres != nil, self.vm.formats != nil {
                self.vm.fetchAnimes(onceAgainOnFailed: true)
            }
        }
        
//                stackView.leftToShow = 0
        
        vm.onListenerError = { error in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        vm.cleanCoordinatorIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(messageLabel)
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        
        
        
        self.view.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(historyButton)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(newMatchesPoint)
        newMatchesPoint.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(messageLabel)
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            finishButton.widthAnchor.constraint(equalToConstant: 80),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
            
            historyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            historyButton.widthAnchor.constraint(equalToConstant: 80),
            historyButton.heightAnchor.constraint(equalToConstant: 50),
            
            newMatchesPoint.widthAnchor.constraint(equalToConstant: 15),
            newMatchesPoint.heightAnchor.constraint(equalToConstant: 15),
            newMatchesPoint.trailingAnchor.constraint(equalTo: historyButton.trailingAnchor, constant: 5),
            newMatchesPoint.topAnchor.constraint(equalTo: historyButton.topAnchor, constant: 0),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: finishButton.bottomAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalToConstant: 350),
            stackView.heightAnchor.constraint(equalToConstant: 500),
        ])
    }
    
    //MARK: - Selectors
    @objc private func matchedButtonTapped() {
        newMatchesPoint.visible = false
        vm.goToMatched()
    }
    
    @objc private func finishButtonTapped() {
        vm.finishGame()
    }
}

extension CardGameController: StackViewDelegate {
    
    func swipped(direction: Direction, anime: Anime) {
        switch direction {
        case .left:
            vm.writeLikedAnimes(anime: anime)
        case .right:
            vm.writeSkipped(anime: anime)
        }
    }
    
    
    func tappedView(anime: Anime) {
        self.vm.detailView(anime: anime)
    }
}

extension CardGameController: SwipeCardDataSource {
    
    func selectedCard() -> SwipeCardView {
        return self.stackView.selectedCard!
    }
    
        
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
