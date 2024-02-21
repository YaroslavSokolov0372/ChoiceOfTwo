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
    @Published var searchText = ""
    private (set) var users = [User]()
    
    var subscriptions = Set<AnyCancellable>()
    
    public func searchUsersWith(_ string: String) {
        self.dBManager.searchFriendsWith(string) { users, error in
            if let error = error {
                print("DEBUG: Error happend while requesting search friends", error)
                self.onSearchError?(error)
            }
            
            if let users = users {
                print("DEBUG: Successfully made request")
                self.users = users
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
    
    //MARK: - Coordinator
    public func dismiss() {
        coordinator.dismissScreen()
    }
}
