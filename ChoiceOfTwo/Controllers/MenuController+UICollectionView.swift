//
//  MenuController+UICollectionView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import Foundation
import UIKit

extension MenuController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.historyCollView {
            return 15
        } else {
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == historyCollView {
            return CGSize(width: self.view.frame.width * 0.93, height: self.view.frame.height * 0.3)
//            return CGSize(width: 100, height: 100)
        } else {
            
            if indexPath.row == 0 {
                return CGSize(width: 70, height: 95)
            } else {
                return CGSize(width: 95, height: 95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.historyCollView {
            return 6
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.historyCollView {
            guard let cell = historyCollView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
                    HistoryCellView else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            cell.configure()
            return cell
            
        } else {
            guard let cell = friendsCollView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FriendCellView else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            if indexPath.row == 0 {
                cell.configure(isFirst: true)
            } else {
                cell.configure(isFirst: false)
            }
            return cell
        }
    }
}
