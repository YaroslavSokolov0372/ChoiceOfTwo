//
//  DataBaseManager.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth



class DataBaseManager {
    
    enum FireBaseError: Error {
        case didntFindCurrentUser(String)
        case couldntGetDocument(String)
    }
    
    private let dataBase = Firestore.firestore()
    
    func addStartGameListener(completion: @escaping (_ isGameStarted: Bool, _ justAdddedListener: Bool, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("currentGames")
            .document(userId)
            .collection("players")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(false, false, error)
                }
                
                guard let snapshot = snapshot else {
                    completion(false, false, error)
                    return
                }
                
                
                do {
                    let friends = try snapshot.documents.map({ try $0.data(as: User.self)})
                    if friends.count == 0 {
                        completion(false, true, nil)
                    }
                    if friends.count == 2{
                        completion(true, false, nil)
                    }
                } catch {
                    completion(false, false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                }
            }
    }
    
    func clearInvsInMenu(completion: @escaping (Bool, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("users")
            .document(userId)
            .collection("GameInvFrom")
            .getDocuments { snapshot, error in
                
                guard let snapshot = snapshot else {
                    completion(false, FireBaseError.couldntGetDocument(""))
                    return
                }
                
                do {
                    let users = try snapshot.documents.map({ try $0.data(as: User.self)})
                    for user in  users {
                        self.dataBase
                            .collection("users")
                            .document(userId)
                            .collection("GameInvFrom")
                            .document(user.uid)
                            .delete() { error in
                                if let error = error {
                                    completion(false, error)
                                }
                            }
                    }
                    completion(true, nil)
                } catch {
                    completion(false, error)
                }
            }
    }
    
    func addGameInvListener(completion: @escaping ([User]?, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("users")
            .document(currentUser)
            .collection("GameInvFrom")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                }
                
                guard let snapshot = snapshot  else {
                    completion(nil, FireBaseError.couldntGetDocument(""))
                    return
                }
                
                do {
                    let users = try snapshot.documents.map({ try $0.data(as: User.self)})
                    completion(users, nil)
                } catch {
                    completion(nil, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                }
            }
    }
    
    func sendGameInv(to user: User, completion: @escaping (Bool, Error?) -> Void) {
        
        AuthService().getCurrentUserData { currentU, error in
            if let error = error {
                completion(false, error)
            }
            
            if let currentU = currentU {
                
                self.dataBase
                    .collection("users")
                    .document(user.uid)
                    .collection("GameInvFrom")
                    .document(currentU.uid)
                    .delete() { error in
                        if let _ = error {
                            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                        }
                    }
                
                
                self.dataBase
                    .collection("users")
                    .document(user.uid)
                    .collection("GameInvFrom")
                    .document(currentU.uid)
                    .setData([
                        "uid" : currentU.uid,
                        "username" : currentU.username,
                        "email" : currentU.email,
                        "keywordsForLookUp": currentU.username.generateStringSequence()
                    ]) { error in
                        if let _ = error {
                            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                        }
                    }
            }
        }
        completion(true, nil)
    }
    
//    func declineGameInv(of user: User, completion: @escaping (Bool, Error?) -> Void) {
//        
//        guard let userId = Auth.auth().currentUser?.uid else {
//            completion(false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
//            return
//        }
//        
//        self.dataBase
//            .collection("users")
//            .document(user.uid)
//            .collection("GameInvFrom")
//            .document(userId)
//            .delete() { error in
//                if let _ = error {
//                    completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
//                } else {
//                    completion(true, nil)
//                }
//            }
//    }
    
    func acceptGameInv(of friend: User, completion: @escaping (Bool, Error?) -> Void) {
        
        AuthService().getCurrentUserData { currentU, error in
            if let error = error {
                completion(false, error)
            }
            
            if let currentU = currentU {
                
                self.dataBase.collection("users").document(currentU.uid).collection("GameInvFrom").document(friend.uid).delete { error in
                    if let error = error {
                        completion(false, error)
                    }
                }
                
                self.dataBase
                    .collection("currentGames")
                    .document(friend.uid)
                    .collection("players")
                    .document(friend.uid)
                    .setData([
                        "uid" : friend.uid,
                        "username" : friend.username,
                        "email" : friend.email,
                        "keywordsForLookUp": friend.username.generateStringSequence()
                    ]) { error in
                        if let error = error {
                            completion(false, error)
                        }
                    }
                
                self.dataBase
                    .collection("currentGames")
                    .document(friend.uid)
                    .collection("players")
                    .document(currentU.uid)
                    .setData([
                        "uid" : currentU.uid,
                        "username" : currentU.username,
                        "email" : currentU.email,
                        "keywordsForLookUp": currentU.username.generateStringSequence()
                    ]) { error in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
            } else {
                completion(false, error)
            }
        }
    }
    
    func deleteFriend(_ friend: User, completion: @escaping (User?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").document(userId).collection("friends").document(friend.uid).delete { error in
            if let error = error {
                completion(nil, error)
            }
        }
        
        dataBase.collection("users").document(friend.uid).collection("friends").document(userId).delete { error in
            if let error = error {
                completion(nil, error)
            }
        }
        completion(friend, nil)
    }
    
    func fetchFriends(completion: @escaping ([User]?, Error?) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").document(userId).collection("friends")
//            .getDocuments
            .addSnapshotListener
        { snapshot, error in
            
            if let _ = error {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
            guard let snapshot = snapshot  else {
                completion(nil, FireBaseError.couldntGetDocument(""))
                return
            }
            
            do {
                let friends = try snapshot.documents.map({ try $0.data(as: User.self)})
                completion(friends, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            }
            //        return try  snapshot.documents.map({ try $0.data(as: Friend.self)})
        }
    }
    
    func fetchWhomSentFriendship(completion: @escaping([User]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").document(userId).collection("friendshipRequestsTo")
//            .getDocuments
            .addSnapshotListener
        { snapshot, error in
            
            if let _ = error {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
            guard let snapshot = snapshot  else {
                completion(nil, FireBaseError.couldntGetDocument(""))
                return
            }
            
            do {
                let users = try snapshot.documents.map({ try $0.data(as: User.self)})
                completion(users, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            }
        }
    }
    
    func fetchUsersWhoSentFriendshipListener(completion: @escaping ([User]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").document(userId).collection("friendshipRequestFrom").addSnapshotListener { snapshot, error in
            
            if let _ = error {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
            guard let snapshot = snapshot  else {
                completion(nil, FireBaseError.couldntGetDocument(""))
                return
            }
            
            do {
                let friends = try snapshot.documents.map({ try $0.data(as: User.self)})
                print(friends.count)
                completion(friends, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            }
        }
    }
    
//    func fetchUsersWhoSentFriendship(completion: @escaping ([User]?, Error?) -> Void) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
//            return
//        }
//        
//        dataBase.collection("users").document(userId).collection("friendshipRequestFrom").getDocuments { snapshot, error in
//            
//            if let _ = error {
//                completion(nil, FireBaseError.couldntGetDocument(""))
//            }
//            guard let snapshot = snapshot  else {
//                completion(nil, FireBaseError.couldntGetDocument(""))
//                return
//            }
//            
//            do {
//                let friends = try snapshot.documents.map({ try $0.data(as: User.self)})
//                completion(friends, nil)
//            } catch {
//                completion(nil, FireBaseError.couldntGetDocument("Couldn't get Documents"))
//            }
//        }
//    }
    
    func searchInRecievedInv(with string: String, completion: @escaping ([User]?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").document(currentUser.uid).collection("friendshipRequestFrom").whereField("keywordsForLookUp", arrayContainsAny: [string])
            .getDocuments { snapshot, error in
            guard let snapshot = snapshot?.documents, error == nil else {
                completion(nil, FireBaseError.couldntGetDocument(""))
                return
            }
            do {
                let users = try snapshot.compactMap({ try $0.data(as: User.self)})
                
                completion(users, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
        }
    }
    
    func searchFriendsWith(_ string: String, completion: @escaping ([User]?, Error?) -> Void) {
        
        guard let currentUser  = Auth.auth().currentUser else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").whereField("keywordsForLookUp", arrayContainsAny: [string]).getDocuments { snapshot, error in
            guard let snapshot = snapshot?.documents, error == nil else {
                completion(nil, FireBaseError.couldntGetDocument(""))
                return
            }
            do {
                var users = try snapshot.compactMap({ try $0.data(as: User.self)})
                users = users.filter({ $0.uid != currentUser.uid })
                completion(users, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
        }
    }
    
    func declineSentFriendShipReq(from user: User, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            return
        }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .collection("friendshipRequestsTo")
            .document(user.uid)
            .delete { error in
                if let error = error {
                    completion(false, error)
                }
            }
        
        dataBase
            .collection("users")
            .document(user.uid)
            .collection("friendshipRequestFrom")
            .document(currentUser.uid)
            .delete { error in
                if let error = error {
                    completion(false, error)
                }
            }
        completion(true, nil)
    }
    
    func sendFriendRequest(to user: User, completion: @escaping (Bool, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            return
        }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .collection("friendshipRequestsTo")
            .document(user.uid)
            .setData([
                "uid" : user.uid,
                "username" : user.username,
                "email" : user.email,
                "keywordsForLookUp": user.username.generateStringSequence()
            ]) { error in
                if let _ = error {
                    completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                }
            }
        
        
        AuthService().getCurrentUserData { currentU, error in
            if let error = error {
                completion(false, error)
            }
            
            if let currentU = currentU {
                self.dataBase
                    .collection("users")
                    .document(user.uid)
                    .collection("friendshipRequestFrom")
                    .document(currentUser.uid)
                    .setData([
                        "uid" : currentU.uid,
                        "username" : currentU.username,
                        "email" : currentU.email,
                        "keywordsForLookUp": currentU.username.generateStringSequence()
                    ]) { error in
                        if let _ = error {
                            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                        }
                    }
            }
        }
        completion(true, nil)
    }
    
    func declineFriendship(from user: User, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            return
        }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
//        friendshipRequestFrom
//            .collection("friendshipRequestsTo")
            .collection("friendshipRequestFrom")
            .document(user.uid)
            .delete { error in
                if let error = error {
                    completion(false, error)
                }
            }
        
        dataBase
            .collection("users")
            .document(user.uid)
            .collection("friendshipRequestsTo")
//            .collection("friendshipRequestFrom")
            .document(currentUser.uid)
            .delete { error in
                if let error = error {
                    completion(false, error)
                }
            }
        completion(true, nil)
    }
    
    func acceptFriendship(from user: User, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            return
        }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .collection("friendshipRequestFrom")
            .document(user.uid)
            .delete { error in
                if let error = error {
                    completion(false, error)
                }
            }
        
        dataBase
            .collection("users")
            .document(user.uid)
            .collection("friendshipRequestsTo")
            .document(currentUser.uid)
            .delete { error in
                if let error = error {
                    completion(false, error)
                }
            }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .collection("friends")
            .document(user.uid)
            .setData([
                "uid" : user.uid,
                "username" : user.username,
                "email" : user.email
            ]) { error in
                if let _ = error {
                    completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                }
            }
        
        AuthService().getCurrentUserData { currentUser, error in
            if let error = error {
                completion(false, error)
            }
            
            if let currentU = currentUser  {
                self.dataBase
                    .collection("users")
                    .document(user.uid)
                    .collection("friends")
                    .document(currentU.uid)
                    .setData([
                        "uid" : currentU.uid,
                        "username" : currentU.username,
                        "email" : currentU.email
                    ]) { error in
                        if let _ = error {
                            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                        }
                    }
            } else {
                completion(false, error)
            }
        }
        
        completion(true, nil)
    }
}
