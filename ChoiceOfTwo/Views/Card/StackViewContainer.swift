//
//  StackViewContainer.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 21/03/2024.
//

import UIKit

class StackViewContainer: UIView {
    
    
    
    //MARK: - Variables
    
    let horizontalInset: CGFloat = 10.0
    let verticalInset: CGFloat = 10.0
    
    var dataSource: SwipeCardDataSource? {
        didSet {
            reloadData()
            print("Anime count -", visibleCardViews.count)
        }
    }
    
    private var remainingCards: Int = 0
    
    static let numberOfVisibleCards: Int = 3
    
    private var cardViews: [SwipeCardView] = []
    
    private var cardInfoViews: [SwipeCardInfoView] = []
    
    private var visibleCardInfoView: [SwipeCardInfoView] {
        return subviews as? [SwipeCardInfoView] ?? []
    }
    
    private var visibleCardViews: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Func
    func reloadData () {
        guard let dataSource = dataSource else { return }
        
        remainingCards = dataSource.numberOfCardsToShow()
        
        for i in 0..<min(remainingCards, StackViewContainer.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(at: i), atIndex: i )
            addShortDescription(infoView: dataSource.cardInfo(at: i), atIndex: i)
            
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func addShortDescription(infoView: SwipeCardInfoView, atIndex index: Int) {
        addShortDescriptionFrame(index: index, infoView: infoView)
        cardInfoViews.append(infoView)
        insertSubview(infoView, at: 0)
    }
    
    func addShortDescriptionFrame(index: Int, infoView: SwipeCardInfoView) {
        
        
        let infoViewFrame = CGRect(x: 0, y: 460, width: 350, height: 250)
//        let horizontalInset = (CGFloat(index) * self.horizontalInset)
//        
//        infoViewFrame.size.width -= 2 * horizontalInset
//        infoViewFrame.origin.x += horizontalInset
        infoView.frame = infoViewFrame
    }
    
    func addCardFrame(index: Int, cardView: SwipeCardView) {
        //        var cardViewFrame = self.bounds
        let cardViewFrame = CGRect(x: 0, y: 0, width: 350, height: 450)
        //        var cardViewFrame = CGRect(x: 0, y: 0, width: 350, height: 700)
//        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        //        let verticalInset = CGFloat(index) * self.verticalInset
        
//        cardViewFrame.size.width -= 2 * horizontalInset
//        cardViewFrame.origin.x += horizontalInset
        //        cardViewFrame.origin.y += verticalInset
        
        //        print(cardViewFrame)
        //        cardView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        //        cardView.frame = bounds
        cardView.frame = cardViewFrame
    }
}

extension StackViewContainer: SwipeCardsDelegate {
    
    func swipeDidEnd(on view: SwipeCardView, direction: Direction) {
        guard let datasource = dataSource else { return }
        guard let parent = self.superview else { return }
        view.removeFromSuperview()
        
        UIView.animate(withDuration: 0.2) {
            let index = self.cardViews.firstIndex(of: view)
            switch direction {
            case .left:
                self.cardInfoViews[index!].frame.origin.x -= parent.frame.width
            case .right:
                self.cardInfoViews[index!].frame.origin.x += parent.frame.width
            }
        }
        
        if remainingCards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingCards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
            addShortDescription(infoView: datasource.cardInfo(at: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.addShortDescriptionFrame(index: cardIndex, infoView: self.visibleCardInfoView[cardIndex])
                    self.layoutIfNeeded()
                })
            }
        } else {
            for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
    }
}
