//
//  SearchFriendsController+ScrollViewDelegate.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 25/02/2024.
//

import Foundation
import UIKit

extension SearchFriendsController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.2) {
            self.activeTabIndicatorConstraints =  [
                self.tabIndicator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: (scrollView.contentOffset.x / 2))
            ]
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if decelerate == false {
          self.currentPage = scrollView.currentPage
      }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = scrollView.currentPage
    }
    
}
