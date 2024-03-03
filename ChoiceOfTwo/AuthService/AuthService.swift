//
//  AuthService.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore
import Combine

class AuthService {
    
    public static let shared = AuthService()
    
    public func regusterUser(with request: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        
        let username = request.name
        let email = request.email
        let password = request.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let userResult = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            
            db.collection("users")
                .document(userResult.uid)
                .setData([
                    "uid": userResult.uid,
                    "username": username,
                    "email": email,
                    "keywordsForLookUp": username?.generateStringSequence()
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                }
            
            completion(true, nil)
        }
    }
    
    public func registerWithGoogle(viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            guard error == nil else {
                completion(false, error)
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString
            else {
                completion(false, nil)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            
            
            
            Auth.auth().signIn(with: credential) { result, error in
                
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let userResult = result?.user else {
                    completion(false, nil)
                    return
                }
                
                let db = Firestore.firestore()
                
                
                db.collection("users")
                    .document(userResult.uid)
                    .setData([
                        "uid": userResult.uid,
                        "username": fullName == nil ? givenName! : fullName!,
                        "email": emailAddress!,
                        "keywordsForLookUp": fullName == nil ? givenName!.generateStringSequence() : fullName!.generateStringSequence()
                    ]) { error in
                        if let error = error {
                            completion(false, error)
                            return
                        }
                    }
                completion(true, nil)
            }
        }
    }
    
    public func signIn(with request: RegisterUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: request.email, password: request.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch {
            completion(error)
        }
    }
    
    public func isAvailable(_ string: String, inField: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        Firestore.firestore().collection("users").whereField(inField, isEqualTo: string).getDocuments { snapshot, error in
            if let error = error, snapshot == nil {
                completionHandler(false, error)
            }
            if snapshot!.documents.count == 0 {
                completionHandler(true, nil)
            } else {
                completionHandler(false, nil)
            }
        }
    }
    
    public func getCurrentUserData(completion: @escaping (User?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("users").document(currentUser.uid).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
            }
            
            guard let snapshot = snapshot else {
                completion(nil, nil)
                return
            }
            
            do {
                let user = try snapshot.data(as: User.self)
                completion(user, nil)
            } catch {
                completion(nil, error)
                return
            }
            
        }
    }
}
