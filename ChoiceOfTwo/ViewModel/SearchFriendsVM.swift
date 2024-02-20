//
//  SearchFriendsVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation


class SearchFriendsVM {
    
    var onSearchChange: (() -> Void)?
    var onSearchError: ((Error) -> Void)?
    
    weak var coordinator: SearchFriendsCoordinator!
    private let dBManager = DataBaseManager()
    private (set) var users = [String]()
    
    public func searchUsersWith(_ string: String) {
             self.dBManager.searchFriendsWith(string) { friend, error in
        }
    }
    
    //MARK: - Coordinator
    public func dismiss() {
        coordinator.dismissScreen()
    }
}
