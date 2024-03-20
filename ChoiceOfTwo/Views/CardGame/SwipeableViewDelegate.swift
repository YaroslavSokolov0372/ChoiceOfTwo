//
//  SwipeableViewDelegate.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 19/03/2024.
//

import Foundation


protocol SwipeableViewDelegate {

    func didTap(view: SwipeableView)

    func didBeginSwipe(onView view: SwipeableView)

    func didEndSwipe(onView view: SwipeableView)

}
