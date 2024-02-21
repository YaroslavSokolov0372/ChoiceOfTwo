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
        
        dataBase.collection("users").document(userId).collection("Friends").getDocuments { snapshot, error in
            
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
    
    func searchFriendsWith(_ string: String, completion: @escaping ([User]?, Error?) -> Void) {
        
        guard (Auth.auth().currentUser?.uid) != nil else {
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
                print(snapshot.count)
                let users = try snapshot.compactMap({ try $0.data(as: User.self)})
                
                completion(users, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
        }
    }
    
    func sendFriendRequest(to user: User, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            return
        }
        
            dataBase
                .collection("users")
                .document(currentUser.uid)
                .collection("FriendshipRequestsTo")
                .document(user.uid)
                .setData([
                    "uid" : user.uid,
                    "username" : user.username,
                    "email" : user.email
                ]) { error in
                    if let error = error {
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
                    .collection("FriendshipRequestFrom")
                    .document(currentUser.uid)
                    .setData([
                        "uid" : currentU.uid,
                        "username" : currentU.username,
                        "email" : currentU.email
                    ]) { error in
                        if let error = error {
                            completion(false, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                        }
                    }
            }
        }
        completion(true, nil)
    }
    
}
