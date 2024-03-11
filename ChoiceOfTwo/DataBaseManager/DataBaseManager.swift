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
    
    func fetchFriends(completion: @escaping ([User]?, Error?) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").document(userId).collection("friends").getDocuments { snapshot, error in
            
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
        
        dataBase.collection("users").document(userId).collection("friendshipRequestsTo").getDocuments { snapshot, error in
            
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
        }
    }
    
    func fetchUsersWhoSentFriendship(completion: @escaping ([User]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").document(userId).collection("friendshipRequestFrom").getDocuments { snapshot, error in
            
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
        }
    }
    
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
        
        dataBase.collection("users").whereField("keywordsForLookUp", arrayContainsAny: [string])
        /*dataBase.collection("users").whereField("username", arrayContains: string)*/.getDocuments { snapshot, error in
            
            //            if let _ = error {
            //                completion(nil, FireBaseError.couldntGetDocument(""))
            //            }
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
