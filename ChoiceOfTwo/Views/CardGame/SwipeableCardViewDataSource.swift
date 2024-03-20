//
//  SwipeableCardViewDataSource.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 19/03/2024.
//

import Foundation
import UIKit

protocol SwipeableCardViewDataSource {
    
    func numberOfCards() -> Int
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard
    
    func viewForEmptyCards() -> UIView?
    
}
