//
//  MenuVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/02/2024.
//

import Foundation

class MenuVM {
    weak var coordinator: MenuCoordiantor!
    private let authService = AuthService()
    private let dBManager = DataBaseManager()
    
    private (set) var friends = [User]() {
        didSet {
            onFriendsUpdated?()
        }
    }
    
    var onFriendsUpdated: (() -> Void)?
    var onFriendsError: ((Error) -> Void)?
    var onSendInvUpdated: (() -> Void)?
    var onSendInvError: (() -> Void)?
    var onGameInvListenerChange: (([User]) -> Void)?
    var onDeletingFriendError: (() -> Void)?
    var onDeletingFriendSuccess: ((User) -> Void)?
    
    
    
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
    
    public func addGameInvListener() {
        dBManager.addGameInvListener { users, error in
            if let _ = error { } else {
                if let users = users {
                    self.onGameInvListenerChange?(users)
                    print("DEBUG: Users count on GameInvListener", users.count)
                }
            }
        }
    }
    
    public func sendInv(to user: User) {
        dBManager.sendGameInv(to: user) { success, error in
            if let _ = error {
                print("Failed to send Game Request")
                self.onSendInvError?()
            } else {
                if success {
                    print("Successfully sent game inv")
                    self.onSendInvUpdated?()
                }
            }
        }
    }
    
    public func deleteFriend(friend: User) {
        
        //MARK: - To really delete friends just bring back thi code
//        self.dBManager.deleteFriend(friend) { deletedFriend, errror in
//            if let error = errror {
//                print("Failed to delete friend")
//                self.onDeletingFriendError?()
//                
//            } else {
//                if let user = deletedFriend {
//                    print("Successfully deleted friend")
//                    self.onDeletingFriendSuccess?(user)
//                }
//            }
//        }
        print("Successfully deleted friend")
        self.onDeletingFriendSuccess?(friend)
    }
    
    
    
    init() {
        self.getFriends()
        self.addGameInvListener()
    }
    
    //MARK: - Coordination
    public func searchFirends() {
        coordinator.searchFriends(friends: friends)
    }
    public func profile() {
        coordinator.profile()
    }
    
    public func dismissHomeScreens() {
        self.coordinator.dismissHomeScreens()
    }
    
    public func removeFriend(at index: Int) {
        self.friends.remove(at: index)
    }
}
