//
//  MenuVM.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/02/2024.
//

import Foundation
import UIKit

class MenuVM {
    weak var coordinator: MenuCoordiantor!
    private let authService = AuthService()
    private let dBManager = DataBaseManager()
    
    private (set) var friends = [User]() {
        didSet {
            onFriendsUpdated?()
        }
    }
    private (set) var matches = [Match]() {
        didSet {
            if matches.count != oldValue.count {
                print("I am here")
                onMatchesUpadated?()
            }
        }
    }
    
    private (set) var isFetchingFriends = true {
        didSet {
            if isFetchingCurrentUserImage == false &&
                isFetchingFriends == false && isFetchingMatches == false {
                isFetchedOnce = true
                onFinishingFetching?()
            }
        }
    }
    
    private (set) var isFetchingMatches = true {
        didSet {
            if isFetchingCurrentUserImage == false &&
                isFetchingFriends == false && isFetchingMatches == false {
                onFinishingFetching?()
                isFetchedOnce = true
            }
        }
    }
    private (set) var isFetchingCurrentUserImage = true {
        didSet {
            if isFetchingCurrentUserImage == false &&
                isFetchingFriends == false && isFetchingMatches == false {
                isFetchedOnce = true
                onFinishingFetching?()
            }
        }
    }
    private (set) var isFetchedOnce = false
    
    var onFinishingFetching: (() -> ())?
    
    var onMatchesUpadated: (() -> Void)?
    var onFriendsUpdated: (() -> Void)?
    var onFriendsError: ((Error) -> Void)?
    var onSendInvUpdated: (() -> Void)?
    var onSendInvError: (() -> Void)?
    var onGameInvListenerChange: (([User]) -> Void)?
    var onDeletingFriendError: (() -> Void)?
    var onDeletingFriendSuccess: ((User) -> Void)?
    
    
    
    var onProfileImageChanges: ((Data) -> Void)?
    var onProfileImageError: ((Error?, String?) -> Void)?
    
    init() {
        self.prepareGameInv()
        self.getFriends()
        self.addCurrentGameListener()
        self.fetchCurrentUserProfImage()
    }
    
    private func startGame() {
        coordinator.game()
    }
    
    private func fetchCurrentUserProfImage() {
        self.isFetchingCurrentUserImage = true
        self.dBManager
            .fetchProfileImage(forCurrentUser: true) { data, error in
                if let error = error {
                    print("Failed current user prof image url", error)
                    self.onProfileImageError?(error, nil)
                    self.isFetchingCurrentUserImage = false
                } else {
                    if let data = data {
                        print("Fetched current user prof image url")
                        self.onProfileImageChanges?(data)
                        self.isFetchingCurrentUserImage = false
                    } else {
                        self.onProfileImageError?(nil, "No data in absolut str")
                    }
                }
            }
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
    
    private func addCurrentGameListener() {
        self.dBManager.addCurrentGameListener { hasGame, error in
            if let error = error {
                print("Failed to get info from current game listener", error)
            } else {
                if hasGame {
                    print("There is an active game")
                    self.startGame()
                } else {
                    print("Added setup game listener")
                }
            }
        }
    }
    
    private func addGameInvListener() {
        dBManager.addGameInvListener { users, error in
            if let _ = error { } else {
                if let users = users {
                    self.onGameInvListenerChange?(users)
                }
            }
        }
    }
    
    private func prepareGameInv() {
        self.dBManager.clearInvsInMenu { success, error in
            if let error = error {
                print("DEBUG: - Error while cleaning game inv", error)
            } else {
                if success {
                    print("DEBUD: - Successfully cleaned game inv")
                    self.addGameInvListener()
                }
            }
        }
    }
    
    public func getFriends() {
        self.isFetchingFriends = true
        dBManager.fetchFriends { friends, error in
            if let error = error {
                (self.onFriendsError)?(error)
                self.isFetchingFriends = false
                print("DEBUG:", error)
            } else {
                if let friends = friends {
                    self.friends = friends
                    self.isFetchingFriends = false
                    self.onFriendsUpdated?()
                    print("DEBUG: Found Friends:", friends.count)
                }
            }
        }
    }
    
    public func getHistory() async {
        self.isFetchingMatches = true
        await dBManager.fetchHistory { matches, error in
            if let error = error {
                print("Failed to load history", error)
                self.isFetchingMatches = false
            } else {
                if let matches = matches {
                    
                    let newMatches = matches.sorted { match1, match2 in
                        let date1 = match1.date.dateValue()
                        let date2 = match2.date.dateValue()
                        return date1 > date2
                    }
                    
                    let isEqual = newMatches.elementsEqual(self.matches) { match, match1 in
                        match.date == match1.date
                    }
                    
                    
                    if !isEqual {
                        self.matches = newMatches
                    }
                    
//                    self.matches = matches.sorted { match1, match2 in
//                        let date1 = match1.date.dateValue()
//                        let date2 = match2.date.dateValue()
//                        return date1 > date2
//                    }
                    
                    
                    self.isFetchingMatches = false
                    print("Matches count -", matches.count)
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
        
        print("Successfully deleted friend")
        self.onDeletingFriendSuccess?(friend)
    }
    
    public func acceptGameInv(of friend: User) {
        self.dBManager.acceptGameInv(of: friend) { accepted, error in
            if let error = error {
                print("Failed to accept invite", error)
            } else {
                if accepted {
                    print("accepted game invite")
                }
            }
        }
    }
    
    //MARK: - Coordination
    public func searchFirends() {
        coordinator.searchFriends(friends: friends)
    }
    
    public func profile(image: UIImage) {
        coordinator.profile(image: image)
    }
    
    public func matchDetail(match: Match) {
        coordinator.matcDetail(match: match)
    }
    
    public func dismissHomeScreens() {
        self.coordinator.dismissHomeScreens()
    }
    
    public func removeFriend(at index: Int) {
        self.friends.remove(at: index)
    }
    
    public func removeListeners() {
        self.dBManager.removeInvListener()
        self.dBManager.removeCurrentGameListener()
    }
}
