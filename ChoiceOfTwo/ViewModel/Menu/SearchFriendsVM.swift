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
    
    
    var friends: [User] = []
    var onSearchChange: (() -> Void)?
    var onSearchError: ((Error) -> Void)?
    var onFriendReqError: ((Error) -> Void)?
    var onFriendReqChange: (() -> Void)?
    var onWhomSentReqDecline: (() -> Void)?
    var onWhomSentReqDeclineError: ((Error) -> Void)?
    var onUsersWhoSentFriendshipAction: (() -> Void)?
    var onUsersWhoSentFriendShipError: ((Error) -> Void)?
    var onFetchWhomSentFriendshipAction: (() -> Void)?
    
    
    @Published var searchText = ""
    private (set) var searchUsers = [User]()
    private (set) var sentInvUsers = [User]()
    private (set) var whomSentInvUsers = [User]()
    
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
                self.searchUsers = users.filter({ user in
                    if self.friends.isEmpty {
                        return true
                    } else {
                        return self.friends.contains(where: { $0.uid != user.uid })
                    }
                })
                self.onSearchChange?()
            }
        }
    }
    
    public func sendFriendShipReq(to user: User, completion: @escaping (Bool) -> Void) {
        dBManager.sendFriendRequest(to: user) { success, error in
            if let error = error {
                print("DEBUG: Error happend while sending friend request", error)
                self.onFriendReqError?(error)
            }
            if success {
                print("DEBUG: Successfully sent request")
                self.onFriendReqChange?()
                completion(success)
            }
        }
    }
    
    public func declineWhomSentReq(from user: User, completion: @escaping (Bool) -> Void) {
//        self.dBManager.declineFriendship(from: user) { success, error in
        self.dBManager.declineSentFriendShipReq(from: user) { success, error in
            if let error = error {
                print("DEBUG: Error happend while sending friend request", error)
                self.onWhomSentReqDeclineError?(error)
            }
            if success {
                print("DEBUG: Successfully sent request")
                completion(success)
                self.onWhomSentReqDecline?()
            }
        }
    }
    
    public func fetchWhomSentFriendship() {
        self.dBManager.fetchWhomSentFriendship { users, error in
            if let error = error {
                print("DEBUG: Error happend while requesting users who sent friendship request", error)
            }
            if let users = users {
                print("DEBUG: Successfully fetched users who sent friendship inv")
                print("DEBUG: Found users who sent friendship inv:", users.count)
                self.whomSentInvUsers = users
                self.onFetchWhomSentFriendshipAction?()
            }
        }
    }
    
    public func fetchUsersSentFriendship() {
//        self.dBManager.fetchUsersWhoSentFriendship { users, error in
        self.dBManager.fetchUsersWhoSentFriendshipListener { users, error in
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
    
    public func declineFriendship(user: User, completion: @escaping (Bool) -> Void) {
        self.dBManager.declineFriendship(from: user) { declined, error in
            if let error = error {
                print("DEBUG: Error happend while declining the user who sent friendship request", error)
//                self.onUsersWhoSentFriendShipError?(error)
            }
            if declined {
                print("DEBUG: Successfully declined inv")
//                self.onUsersWhoSentFriendshipAction?()
                completion(true)
            }
        }
    }
    
    public func acceptFriendship(user: User, completion: @escaping (Bool) -> Void) {
        self.dBManager.acceptFriendship(from: user) { accepted, error in
            if let error = error {
                print("DEBUG: Error happend while accepting the user who sent friendship request", error)
//                self.onUsersWhoSentFriendShipError?(error)
            }
            if accepted {
                print("DEBUG: Successfully accepted inv")
//                self.onUsersWhoSentFriendshipAction?()
                completion(true)
            }
        }
    }
    
    public func removeSearchUsers() {
        self.searchUsers = []
        onSearchChange?()
    }
    
    public func removeSentInvUsers(at index: Int) {
        self.sentInvUsers.remove(at: index)
    }
    
    func fetchProfImage(for uid: String, completion: @escaping (Data) -> () ) {
        self.dBManager
            .fetchProfileImage(forCurrentUser: false, for: uid) { data, error in
                if let error = error {
                    print("Failed current user prof image url", error)
                } else {
                    if let data = data {
                        completion(data)
                    } else {
                        print("No data found for friend's prof image")
                    }
                }
            }
    }

    
    
 
    //MARK: - Coordinator
    public func dismiss() {
        coordinator.dismissScreen()
    }
}
