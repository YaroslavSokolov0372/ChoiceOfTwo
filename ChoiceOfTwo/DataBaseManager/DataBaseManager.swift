//
//  DataBaseManager.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 20/02/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth



class DataBaseManager {
    
    enum FireBaseError: Error {
        case didntFindCurrentUser(String)
        case couldntGetDocument(String)
    }
    
    private let dataBase = Firestore.firestore()
    
    func fetchFriends(completion: @escaping ([Friend]?, Error?) -> Void) {
        
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
                let friends = try snapshot.documents.map({ try $0.data(as: Friend.self)})
                completion(friends, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument("Couldn't get Documents"))
            }
            //        return try  snapshot.documents.map({ try $0.data(as: Friend.self)})
        }
    }
    
    func searchFriendsWith(_ string: String, completion: @escaping ([Friend]?, Error?) -> Void) {
        
        guard (Auth.auth().currentUser?.uid) != nil else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        dataBase.collection("users").whereField("username", arrayContains: string).getDocuments { snapshot, error in
            
            if let _ = error {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
            guard let snapshot = snapshot else {
                completion(nil, FireBaseError.couldntGetDocument(""))
                return
            }
            do {
                let users = try snapshot.documents.map({ try $0.data(as: Friend.self)})
                completion(users, nil)
            } catch {
                completion(nil, FireBaseError.couldntGetDocument(""))
            }
        }
    }
    
    //    func sendFriendRequest() {
    //
    //    }
}
