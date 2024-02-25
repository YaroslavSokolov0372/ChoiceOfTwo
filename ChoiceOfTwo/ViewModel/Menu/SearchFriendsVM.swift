//
//  SearchFriendsVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation
import Combine


class SearchFriendsVM {
    
    weak var coordinator: SearchFriendsCoordinator!
    private let dBManager = DataBaseManager()
    
    var onSearchChange: (() -> Void)?
    var onSearchError: ((Error) -> Void)?
    var onFriendReqError: ((Error) -> Void)?
    var onFriendReqChange: (() -> Void)?
    var onUsersWhoSentFriendshipAction: (() -> Void)?
    var onUsersWhoSentFriendShipError: ((Error) -> Void)?
    
    @Published var searchText = ""
    private (set) var searchUsers = [User]()
    private (set) var sentInvUsers = [User]()
    
    var subscriptions = Set<AnyCancellable>()
    
    public func searchInRecievedInv(with string: String) {
        self.dBManager.searchInRecievedInv(with: string) { users, error in
            if let error = error {
                print("DEBUG: Error happend while requesting search through recieved inv", error)
                self.onUsersWhoSentFriendShipError?(error)
            }
            if let users = users {
                print("DEBUG: Successfully made search in recieved inv tab ")
                print("DEBUG: Found users by search in recieved inv tab:", users.count)
                self.sentInvUsers = users
                self.onUsersWhoSentFriendshipAction?()
            }
        }
    }
    
    public func searchUsersWith(_ string: String) {
        self.dBManager.searchFriendsWith(string) { users, error in
            if let error = error {
                print("DEBUG: Error happend while requesting search friends", error)
                self.onSearchError?(error)
            }
            
            if let users = users {
                print("DEBUG: Successfully made for search request")
                print("DEBUG: Found users by search:", users.count)
                self.searchUsers = users
                self.onSearchChange?()
            }
        }
    }
    
    public func sendFriendShipReq(to user: User) {
        dBManager.sendFriendRequest(to: user) { succes, error in
            if let error = error {
                print("DEBUG: Error happend while sending friend request", error)
                self.onFriendReqError?(error)
            }
            if succes {
                print("DEBUG: Successfully sent request")
                self.onFriendReqChange?()
            }
        }
    }
    
    public func fetchUsersSentFriendship() {
        self.dBManager.fetchUsersWhoSentFriendship { users, error in
            if let error = error {
                print("DEBUG: Error happend while requesting users who sent friendship request", error)
                self.onUsersWhoSentFriendShipError?(error)
            }
            if let users = users {
                print("DEBUG: Successfully fetched users who sent friendship inv")
                print("DEBUG: Found users who sent friendship inv:", users.count)
                self.sentInvUsers = users
                self.onUsersWhoSentFriendshipAction?()
            }
        }
    }
    
    public func declineFriendship(user: User) {
        self.dBManager.declineFriendship(from: user) { declined, error in
            if let error = error {
                print("DEBUG: Error happend while declining the user who sent friendship request", error)
                self.onUsersWhoSentFriendShipError?(error)
            }
            if declined {
                print("DEBUG: Successfully declined inv")
                self.onUsersWhoSentFriendshipAction?()
            }
        }
    }
    
    public func acceptFriendship(user: User) {
        self.dBManager.acceptFriendship(from: user) { accepted, error in
            if let error = error {
                print("DEBUG: Error happend while accepting the user who sent friendship request", error)
                self.onUsersWhoSentFriendShipError?(error)
            }
            if accepted {
                print("DEBUG: Successfully accepted inv")
                self.onUsersWhoSentFriendshipAction?()
            }
        }
    }
    
    
    public func removeSearchUsers() {
        self.searchUsers = []
        onSearchChange?()
    }
    
    
 
    //MARK: - Coordinator
    public func dismiss() {
        coordinator.dismissScreen()
    }
}
