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
        return self.vm.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? UserSearchCellView else {
            fatalError("Unenable to dequeue AnimePreviewCell in MenuCntroller")
        }
        
        cell.configure(with: vm.users[indexPath.row])
        cell.delegate = self
        return cell
    }
}





