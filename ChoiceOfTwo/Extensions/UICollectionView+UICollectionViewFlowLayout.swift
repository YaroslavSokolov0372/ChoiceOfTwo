//
//  UICollectionView+UICollectionViewFlowLayout.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 25/02/2024.
//

import Foundation
import UIKit

class MyCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if ((attributes == nil)){
            attributes = self.layoutAttributesForItem(at: itemIndexPath)
        }
        attributes?.transform = CGAffineTransform(scaleX: 0, y: 0)
        attributes?.zIndex = -1
        attributes?.alpha = 1
        
        return attributes
    }
}

