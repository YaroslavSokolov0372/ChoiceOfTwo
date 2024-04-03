//
//  MenuController+UICollectionView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/02/2024.
//

import Foundation
import UIKit
import SkeletonView

extension MenuController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "Cell"
    }
    
    
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
            return vm.matches.isEmpty ? 3 : vm.matches.count
        } else {
            return vm.friends.isEmpty ? 4 : vm.friends.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.historyCollView {
            
            guard let cell = historyCollView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
                    HistoryCellView else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            if vm.isFetchingMatches == false {
                if cell.match != nil {
                    if cell.match.date == vm.matches[indexPath.row].date {
                        cell.configure(with: vm.matches[indexPath.row], shouldReloadData: false)
                    }
                } else {
                    cell.configure(with: vm.matches[indexPath.row])
                }
                
                cell.delegate = self
                vm.fetchProfImage(for: vm.matches[indexPath.row].playedWithUID) { data in
                    cell.circleImage.image = UIImage(data: data)
                }
            }
            return cell
        } else {
            guard let cell = friendsCollView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FriendCellView else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            if vm.isFetchingFriends == false {
                if indexPath.row == 0 {
                    cell.configure(isFirst: true)
                    cell.addFriendsDelegate = self
                } else {
                    cell.configure(isFirst: false, with: vm.friends[indexPath.row - 1])
                    cell.friendsDelegate = self
                    
                    vm.fetchProfImage(for: vm.friends[indexPath.row - 1].uid) { data in
                        cell.circleImage.image = UIImage(data: data)
                    }
                }
            } else {
                if indexPath.row == 0 {
                    cell.configure(isFirst: true)
                    cell.isSkeletonable = false
                    cell.addFriendsDelegate = self
                }
            }
            return cell
        }
    }
}



