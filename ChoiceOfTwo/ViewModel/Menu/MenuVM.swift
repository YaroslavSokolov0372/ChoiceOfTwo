//
//  MenuVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/02/2024.
//

import Foundation

class MenuVM {
    
    
    var onFriendsUpdated: (() -> Void)?
    var onFriendsError: ((Error) -> Void)?
    
    weak var coordinator: MenuCoordiantor!
    private let authService = AuthService()
    private let dBManager = DataBaseManager()
    
    private (set) var friends = [User]() {
        didSet {
            onFriendsUpdated?()
        }
    }
    
    public func getFriends() {
        dBManager.fetchFriends { friends, error in
            if let error = error {
                (self.onFriendsError)?(error)
                print("DEBUG:", error)
            } else {
                if let friends = friends {
                    self.friends = friends
                    self.onFriendsUpdated?()
                    print("DEBUG: Found Friends:", friends.count)
                }
            }
        }
    }
    
    init() {
        self.getFriends()
    }
    
    //MARK: - Coordination
    public func searchFirends() {
        coordinator.searchFriends()
    }
    public func profile() {
        coordinator.profile()
    }
    
    public func dismissHomeScreens() {
        self.coordinator.dismissHomeScreens()
    }
    
    
}
