//
//  SearchFriends+UICollectionView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation
import UIKit


extension SearchFriendsController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.usersSearchCollView {
            return self.vm.searchUsers.count
        } else {
            return self.vm.sentInvUsers.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.usersSearchCollView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? UserSearchCellView else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            
            if vm.whomSentInvUsers.contains(where: { $0.uid == vm.searchUsers[indexPath.row].uid }) {
                cell.configure(with: vm.searchUsers[indexPath.row], alrdSentInv: true)
            } else {
                cell.configure(with: vm.searchUsers[indexPath.row], alrdSentInv: false)
            }
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? RecievedCellView else {
                fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
            }
            cell.configure(with: vm.sentInvUsers[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        }
    }
    
}





