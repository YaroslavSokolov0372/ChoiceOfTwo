//
//  SwipeCardsDataSource.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 21/03/2024.
//

import Foundation
import UIKit

protocol SwipeCardDataSource {
    
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func cardInfo(at index: Int) -> SwipeCardInfoView
    func emptyView() -> UIView?
    
}

