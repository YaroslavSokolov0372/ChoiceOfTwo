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
                    "username": username,
                    "email": email
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
                        "username": fullName ?? givenName,
                        "email": emailAddress
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
}
