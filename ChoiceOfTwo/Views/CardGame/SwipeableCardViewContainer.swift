//
//  SwipeableCardViewContainer.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 19/03/2024.
//

import UIKit

class SwipeableCardViewContainer: UIView, SwipeableViewDelegate {

    

    
    //MARK: - Variables
    var delegate: SwipeableCardViewDelegate?
    
    var dataSource: SwipeableCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    private var cardViews: [SwipeableCardViewCard] = []
    
    private var visibleCardViews: [SwipeableCardViewCard] {
        return subviews as? [SwipeableCardViewCard] ?? []
    }
    
    private var remainingCards: Int = 0

    static let numberOfVisibleCards: Int = 3
    
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = .mainDarkGray
        self.backgroundColor = .mainRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        removeAllCards()
        
        guard let dataSource = dataSource else {
            return
        }
        
        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards
        
        for index in 0..<min(numberOfCards, SwipeableCardViewContainer.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        
        if let emptyView = dataSource.viewForEmptyCards() {
//            addEdgeConstrainedSubView(view: emptyView)
        //MARK: - DO SOMTH
        }

        setNeedsLayout()
    }
    
    private func addCardView(cardView: SwipeableCardViewCard, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func removeAllCards() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    private func setFrame(forCardView cardView: SwipeableCardViewCard, atIndex index: Int) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * 12)
        let verticalInset = (CGFloat(index) * 12)
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset

        cardView.frame = cardViewFrame
    }
    
}


extension SwipeableCardViewContainer {  
    
    func didTap(view: SwipeableView) {
        if let cardView = view as? SwipeableCardViewCard,
           let index = cardViews.firstIndex(of: cardView) {
            delegate?.didSelect(card: cardView, atIndex: index)
        }
    }
    
    func didBeginSwipe(onView view: SwipeableView) {
        
    }
    
    func didEndSwipe(onView view: SwipeableView) {
        guard let dataSource = dataSource else {
            return
        }

        view.removeFromSuperview()

        if remainingCards > 0 {

            let newIndex = dataSource.numberOfCards() - remainingCards

            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)

            for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                })
            }

        }
    }
}
