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
    private (set) var matches = [Match]() {
        didSet {
            onMatchesUpadated?()
        }
    }
    
    var onMatchesUpadated: (() -> Void)?
    var onFriendsUpdated: (() -> Void)?
    var onFriendsError: ((Error) -> Void)?
    var onSendInvUpdated: (() -> Void)?
    var onSendInvError: (() -> Void)?
    var onGameInvListenerChange: (([User]) -> Void)?
    var onDeletingFriendError: (() -> Void)?
    var onDeletingFriendSuccess: ((User) -> Void)?
    
    init() {
        self.prepareGameInv()
        self.getFriends()
        self.addCurrentGameListener()
//        self.setupGameListener()
    }
    
    private func startGame() {
        coordinator.game()
    }
    
//    private func setupGameListener() {
//        self.dBManager.addStartGameListener { isGameStarted, justAdddedListener, error in
//            if let error = error {
//                print("Failed to create snapshot listener", error)
//            } else {
//                if isGameStarted {
//                    print("Should start game")
//                    self.startGame()
//                }
//                if justAdddedListener {
//                    print("Added setup game listener")
//                }
//            }
//        }
//    }
    
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
    
    public func getHistory() async {
        await dBManager.fetchHistory { matches, error in
            if let error = error {
                print("Failed to load history", error)
            } else {
                if let matches = matches {
                    self.matches = matches
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
//                    self.coordinator.game()
                }
            }
        }
    }
    
    //MARK: - Coordination
    public func searchFirends() {
        coordinator.searchFriends(friends: friends)
    }
    
    public func profile() {
        coordinator.profile()
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
