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
import FirebaseStorage



class DataBaseManager {
    
    enum FireBaseError: Error {
        case didntFindCurrentUser(String)
        case couldntGetDocument(String)
    }
    
    private let dataBase = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    private var invListener: ListenerRegistration? = nil
    private var currentGameListener: ListenerRegistration? = nil
    private var gameInfoListener: ListenerRegistration? = nil
    private var gamePlayersCountListener: ListenerRegistration? = nil
    
    public func removeInvListener() {
        self.invListener?.remove()
    }
    
    public func removeCurrentGameListener() {
        self.currentGameListener?.remove()
    }
    
    public func removeGameInfoListener() {
        self.gameInfoListener?.remove()
    }
    
    public func removePlayerCountListener() {
        self.gamePlayersCountListener?.remove()
    }
    
    
    func fetchProfileImage(forCurrentUser: Bool = false, for uid: String? = nil, completion: @escaping (/*_ urlStr: String?*/ _ data: Data?, Error?) -> Void) {
        
        if forCurrentUser == true {
            guard let currentUser = Auth.auth().currentUser else {
                completion(nil, FireBaseError.couldntGetDocument("Couldn't get Documents"))
                return
            }
            
            storage.child("ProfImages/\(currentUser.uid).png").getData(maxSize: (1 * 10240 * 10240)) { data, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(data, nil)
                }
            }
        } else {
            guard let uid = uid else {
                completion(nil, nil)
                print("Couldn't fetch prof image bcs no uid found")
                return
            }

            
            storage.child("ProfImages/\(uid).png").getData(maxSize: (1 * 10240 * 10240)) { data, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(data, nil)
                }
            }
//            storage.child("ProfImages/\(uid).png").downloadURL { url, error in
//                if let error = error {
////                    completion(nil, error)
//                } else {
////                    completion(url?.absoluteString, nil)
//                }
//            }
        }
    }

    func writeProfImage(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        let ref = storage.child("ProfImages/\(userId).png")
        
        if let imageData = image.pngData() {
            ref.putData(imageData, metadata: nil) { _, error in
                if let error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
    func addCurrentGameListener(completion: @escaping (_ hasGame: Bool, Error?) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.currentGameListener = self.dataBase
            .collection("users")
            .document(userId)
            .collection("currentGameUID")
            .addSnapshotListener(includeMetadataChanges: false) { snapshot, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let snapshot = snapshot else {
                    completion(false, error)
                    return
                }
                
                if snapshot.documents.count != 0 {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        
    }
    
    func addGameInfoListener(completion: @escaping (_ info: GameInfo?, Error?) -> Void) {
        
        self.getCurrentGameUID { uid, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let uid = uid {
                    self.gameInfoListener = self.dataBase
                        .collection("currentGames")
                        .document(uid)
                        .addSnapshotListener(includeMetadataChanges: false) { snapshot, error in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            guard let snapshot = snapshot else {
                                completion(nil, error)
                                return
                            }
                            
                            do {
                                //                                if !snapshot.metadata.isFromCache {
                                let gameInfo = try snapshot.data(as: GameInfo.self)
                                completion(gameInfo, nil)
                                //                                }
                            } catch {
                                completion(nil, error)
                            }
                        }
                }
            }
        }
    }
    
    func addGameInvListener(completion: @escaping ([User]?, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.invListener = self.dataBase
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
    
    func addFinishGameListener(completion: @escaping (_ numOfGames: Int?, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("users")
            .document(currentUser)
            .collection("history")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let snapshot = snapshot else {
                    completion(nil, error)
                    return
                }
                
                let finishedGamesCount = snapshot.documents.count
                completion(finishedGamesCount, nil)
            }
    }
    
    func addPlayersListener(completion: @escaping(_ count: Int?, Error?) -> Void) {
        
        getCurrentGameUID { uid, error in
            if let error = error {
                completion(nil, error)
                return
            }
            if let uid = uid {
                self.gamePlayersCountListener = self.dataBase
                    .collection("currentGames")
                    .document(uid)
                    .collection("players")
                    .addSnapshotListener { snapshot, error in
                        if let error = error {
                            completion(nil, error)
                            return
                        }
                        
                        guard let snapshot = snapshot else {
                            completion(nil, error)
                            return
                        }
                        
                        completion(snapshot.documents.count, nil)
                    }
            }
        }
    }
    
    func deleteGame(completion: @escaping (_ success: Bool, Error?) -> Void) {
        
        getCurrentGameUID { uid, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            if let uid = uid {
                
                self.dataBase
                    .collection("currentGames")
                    .document(uid)
                    .collection("players")
                    .getDocuments(completion: { snapshot, error in
                        if let error = error {
                            completion(false, error)
                        }
                        guard let snapshot = snapshot else {
                            completion(false, error)
                            return
                        }
                        
                        snapshot.documents.forEach { snapshot in
                            
                            let data = snapshot.data()
                            let userUid = data["uid"]
                            self.dataBase
                                .collection("currentGames")
                                .document(uid)
                                .collection("players")
                                .document(userUid as! String)
                                .delete { error in
                                    if let error = error {
                                        completion(false, error)
                                    }
                                }
                                
                            self.dataBase
                                .collection("users")
                                .document(userUid as! String)
                                .collection("currentGameUID")
                                .document(uid)
                                .delete { error in
                                    if let error = error {
                                        completion(false, error)
                                    }
                                }
                        }
                    })
                
                
                self.dataBase
                    .collection("currentGames")
                    .document(uid)
                    .delete { error in
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
    
    func fetchTags(completion: @escaping (_ succes: ([Genre.RawValue], [Format.RawValue])?, Error?) -> Void) {
        getCurrentGameUID { uid, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let uid = uid {
                
                self.dataBase
                    .collection("currentGames")
                    .document(uid)
                    .getDocument(completion: { snapshot, error in
                        
                        if let error = error {
                            completion(nil, error)
                            return
                        }
                        
                        guard let data = snapshot?.data() else {
                            completion(nil, error)
                            return
                        }
                        
                        let genres = data["genres"] as! [Genre.RawValue]
                        let formats = data["formats"] as! [Format.RawValue]
                        
                        completion((genres, formats), nil)
                    })
            } else {
                completion(nil, error)
                return
            }
        }
    }

    func getCurrentGameUID(completion: @escaping (_ uid: String?, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("users")
            .document(currentUser)
            .collection("currentGameUID")
            .getDocuments(source: .server) { snapshot, error in
                if let error = error {
                    completion(nil, error)
                }
                
                guard let snapshot = snapshot?.documents else {
                    completion(nil, error)
                    return
                }
                
                let data = snapshot.first!.data()
                let gameUid = data["uid"] as! String
                completion(gameUid, nil)
            }
    }
    
    func playerReady(_ players: [String: Bool], completion: @escaping (_ success: Bool, _ isCurrentPlayerReady: Bool, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(false, false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        getCurrentGameUID { uid, error in
            if let error = error {
                completion(false, false, error)
                return
            }
            
            
            var players = players
            let currentPlayerIndex = players.firstIndex(where: { $0.key == currentUser})
            let currentPlayer = players[currentPlayerIndex!]
            
            if currentPlayer.value == true {
                players[currentPlayer.key] = false
            } else {
                players[currentPlayer.key] = true
            }
            
            if let uid = uid {
                self.dataBase
                    .collection("currentGames")
                    .document(uid)
                    .updateData(["ready" : players]) { error in
                        if let error = error {
                            completion(false, false, error)
                        } else {
                            completion(true, players[currentPlayer.key]!, nil)
                        }
                    }
                
            } else {
                completion(false, false, error)
                return
            }
        }
    }
    
    func addGenres(_ genres: [Genre.RawValue], completion: @escaping (_ success: Bool, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("users")
            .document(currentUser)
            .collection("currentGameUID")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let snapshot = snapshot?.documents else {
                    completion(false, error)
                    return
                }
                
                let data = snapshot.first!.data()
                let gameUid = data["uid"] as! String
                
                self.dataBase
                    .collection("currentGames")
                    .document(gameUid)
                    .updateData(["genres" : genres]) { error in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
            }
    }
    
    func addFormats(_ formats: [Format.RawValue], completion: @escaping (_ success: Bool, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("users")
            .document(currentUser)
            .collection("currentGameUID")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let snapshot = snapshot?.documents else {
                    completion(false, error)
                    return
                }
                
                let data = snapshot.first!.data()
                let gameUid = data["uid"] as! String
                
                self.dataBase
                    .collection("currentGames")
                    .document(gameUid)
                    .updateData(["formats" : formats]) { error in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
            }
        
    }
    
    func addSeasons(_ seasons: [Season.RawValue], completion: @escaping (_ success: Bool, Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            completion(false, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.dataBase
            .collection("users")
            .document(currentUser)
            .collection("currentGameUID")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                guard let snapshot = snapshot?.documents else {
                    completion(false, error)
                    return
                }
                
                let data = snapshot.first!.data()
                let gameUid = data["uid"] as! String
                
                self.dataBase
                    .collection("currentGames")
                    .document(gameUid)
                    .updateData(["seasons" : seasons]) { error in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
            }
    }
    
    
    func finishGame(
        matchedAnimes: [Anime],
        completion: @escaping (Bool, Error?) -> Void) {
            
            self.addMatchToHistory(matchedAnimes: matchedAnimes) { saved, error in
                
                if let error = error {
                    completion(false, error)
                    return
                }
                
                if saved != nil {
                    self.getCurrentGameUID { uid, error in
                        if let error = error {
                            completion(false, error)
                            return
                        }
                        
                        if let uid = uid {
                            
                            self.dataBase
                                .collection("currentGames")
                                .document(uid)
                                .collection("players")
                                .getDocuments(completion: { snapshot, error in
                                    if let error = error {
                                        completion(false, error)
                                    }
                                    guard let snapshot = snapshot else {
                                        completion(false, error)
                                        return
                                    }
                                    
                                    var users: [String] = []
                                    
                                    snapshot.documents.forEach { snapshot in
                                        
                                        let data = snapshot.data()
                                        let userUid = data["uid"]
                                        users.append(userUid as! String)
                                    }
                                    
                                    users.forEach { uid in
                                        self.dataBase
                                            .collection("users")
                                            .document(uid)
                                            .collection("currentGameUID")
                                            .document(users[0])
                                            .delete { error in
                                                if let error = error {
                                                    completion(false, error)
                                                }
                                            }
                                        
                                        self.dataBase
                                            .collection("users")
                                            .document(uid)
                                            .collection("currentGameUID")
                                            .document(users[1])
                                            .delete { error in
                                                if let error = error {
                                                    completion(false, error)
                                                }
                                            }
                                    }
                                    
                                    completion(true, nil)
                                })
                            
                        } else {
                            completion(false, error)
                        }
                    }
                }
            }
        }
    
    func addMatchToHistory(
        matchedAnimes: [Anime],
        completion: @escaping (_ saved: Bool?, Error?) -> Void) {
            
            guard let userId = Auth.auth().currentUser?.uid else {
                completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
                return
            }
            
            self.getCurrentGameUID { uid, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    if let uid = uid {
                        self.dataBase
                            .collection("currentGames")
                            .document(uid)
                            .collection("players")
                            .getDocuments { snapshot, error in
                                if let error = error {
                                    completion(nil, error)
                                    return
                                }
                                
                                guard let documents = snapshot?.documents else {
                                    completion(nil, error)
                                    return
                                }
                                
                                var users: [User] = []
                                
                                
                                documents.forEach { snapshot in
                                    do {
                                        let user = try snapshot.data(as: User.self)
                                        users.append(user)
                                    } catch {
                                        completion(nil, error)
                                    }
//                                    let uid = user["uid"] as! String
//                                    users.append(uid)
                                }
                                
                                users.forEach { user in
                                    
                                    let indexInArray = users.firstIndex(where: { $0.uid == user.uid })
                                    
                                    self.dataBase
                                        .collection("currentGames")
                                        .document(uid)
                                        .getDocument { snapshot, error in
                                            if let error = error {
                                                completion(nil, error)
                                                return
                                            }
                                            
                                            guard let data = snapshot?.data() else {
                                                completion(nil, error)
                                                return
                                            }
                                            
                                            self.dataBase
                                                .collection("users")
                                                .document(user.uid)
                                                .collection("history")
                                                .document(uid)
                                                .setData([
                                                    "genres": data["genres"],
                                                    "formats": data["formats"],
                                                    "dateStamp": Date(),
                                                    "gameUID": uid,
                                                    "playedWith": indexInArray == 0 ? users[1].uid : users[0].uid,
                                                    "playersName": indexInArray == 0 ? users[1].username : users[0].username
                                                ])
                                        }
                                    
                                    self.dataBase
                                        .collection("currentGames")
                                        .document(uid)
                                        .collection("playersChoices")
                                        .document(user.uid)
                                        .collection("skipped")
                                        .getDocuments { snapshot, error in
                                            if let error = error {
                                                completion(nil, error)
                                                return
                                            }
                                            
                                            guard let documents = snapshot?.documents else {
                                                completion(nil, error)
                                                return
                                            }
                                            
                                            documents.forEach { document in
                                                do {
                                                    let skippedAnime = try document.data(as: Anime.self)
                                                    try self.dataBase
                                                        .collection("users")
                                                        .document(user.uid)
                                                        .collection("history")
                                                        .document(uid)
                                                        .collection("skipped")
                                                        .document()
                                                        .setData(from: skippedAnime)
                                                } catch {
                                                    completion(nil, error)
                                                    return
                                                }
                                            }
                                        }
                                    
//                                    
//                                    
//                                    skippedAnime.forEach { anime in
//                                        do {
//                                            try self.dataBase
//                                                .collection("users")
//                                                .document(userUID)
//                                                .collection("history")
//                                                .document(uid)
//                                                .collection("skipped")
//                                                .addDocument(from: anime)
//                                        } catch {
//                                            completion(nil, error)
//                                        }
//                                    }
                                    
                                    matchedAnimes.forEach { anime in
                                        do {
                                            try self.dataBase
                                                .collection("users")
                                                .document(user.uid)
                                                .collection("history")
                                                .document(uid)
                                                .collection("matched")
                                                .addDocument(from: anime)
                                        } catch {
                                            completion(nil, error)
                                        }
                                    }
                                }
                                
                                completion(true, nil)
                            }
                    }
                }
            }
        }
    
    func fetchLiked(completion: @escaping ([Anime]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.getCurrentGameUID { uid, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let uid = uid {
                    self.dataBase
                        .collection("currentGames")
                        .document(uid)
                        .collection("playersChoices")
                        .document(userId)
                        .collection("liked")
                        .getDocuments { snapshot, error in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            guard let documents = snapshot?.documents else {
                                completion(nil, error)
                                return
                            }
                            
                            var animes: [Anime] = []
                            documents.forEach { document in
                                do {
                                    let anime = try document.data(as: Anime.self)
                                    animes.append(anime)
                                } catch {
                                    completion(nil, error)
                                }
                            }
                            
                            completion(animes, nil)
                        }
                }
            }
        }
    }
    
    func fetchHistory(completion: @escaping ([Match]?, Error?) -> Void) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        var history: [Match] = []
        
        do {
            let snapshot = try await self.dataBase
                .collection("users")
                .document(userId)
                .collection("history")
                .getDocuments()
                    
            for document in snapshot.documents {
                let data = document.data()
                let genres = data["genres"] as! [Genre.RawValue]
                let formats = data["formats"] as! [Format.RawValue]
                let date = data["dateStamp"] as! Timestamp
                let playedWithUID = data["playedWith"] as! String
                let playersName = data["playersName"] as! String
                var matchedAnimes: [Anime] = []
                var skippedAnimes: [Anime] = []
                
                let id = data["gameUID"]
                
                let matchedDocuments = try await dataBase
                    .collection("users")
                    .document(userId)
                    .collection("history")
                    .document(id as! String)
                    .collection("matched")
                    .getDocuments()
                
                for matchedDocument in matchedDocuments.documents {
                    do {
                        let anime = try matchedDocument.data(as: Anime.self)
                        matchedAnimes.append(anime)
                    } catch {
                        completion(nil, error)
                        return
                    }
                }
                
                let skippedDocuments = try await dataBase
                    .collection("users")
                    .document(userId)
                    .collection("history")
                    .document(id as! String)
                    .collection("skipped")
                    .getDocuments()
                
                for matchedDocument in skippedDocuments.documents {
                    do {
                        let anime = try matchedDocument.data(as: Anime.self)
                        skippedAnimes.append(anime)
                    } catch {
                        completion(nil, error)
                        return
                    }
                }
                
                history.append(Match(skipped: skippedAnimes, matched: matchedAnimes, date: date, genres: genres, formats: formats, playedWithUID: playedWithUID, playersName: playersName))
            }
            completion(history, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func likedAnime(_ anime: Anime, completion: @escaping (_ success: Bool?, Error?) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.getCurrentGameUID { uid, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let uid = uid {
                    do {
                        try self.dataBase
                            .collection("currentGames")
                            .document(uid)
                            .collection("playersChoices")
                            .document(userId)
                            .collection("liked")
                            .addDocument(from: anime)
                        
                        completion(true, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func skippedAnime(_ anime: Anime, completion: @escaping (_ success: Bool?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.getCurrentGameUID { uid, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let uid = uid {
                    do {
                        try self.dataBase
                            .collection("currentGames")
                            .document(uid)
                            .collection("playersChoices")
                            .document(userId)
                            .collection("skipped")
                            .addDocument(from: anime)
                        
                        completion(true, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func addFriendsLikedListener(completion: @escaping (_ liked: [Anime]?, Error?) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, FireBaseError.didntFindCurrentUser("Didn't find current user"))
            return
        }
        
        self.getCurrentGameUID { uid, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let uid = uid {
                    self.dataBase
                        .collection("currentGames")
                        .document(uid)
                        .collection("players")
                        .getDocuments { snapshot, error in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            guard let documents = snapshot?.documents else {
                                completion(nil, error)
                                return
                            }
                            
                            documents.forEach { document in
                                let data = document.data()
                                let userUID = data["uid"] as! String
                                if userId != userUID {
                                    self.dataBase
                                        .collection("currentGames")
                                        .document(uid)
                                        .collection("playersChoices")
                                        .document(userUID)
                                        .collection("liked")
                                        .addSnapshotListener { snapshot, error in
                                            if let error = error {
                                                completion(nil, error)
                                                return
                                            }
                                            
                                            guard let snapshot = snapshot?.documents else {
                                                completion(nil, error)
                                                return
                                            }
                                            
                                            var animes: [Anime] = []
                                            
                                            snapshot.forEach { snapshot in
                                                do {
                                                    let anime = try snapshot.data(as: Anime.self)
                                                    animes.append(anime)
                                                    
                                                    
                                                } catch {
                                                    completion(nil, error)
                                                }
                                            }
                                            completion(animes, nil)
                                        }
                                }
                            }
                        }
                }
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
    
    func acceptGameInv(of friend: User, completion: @escaping (Bool, Error?) -> Void) {
        
        AuthService().getCurrentUserData { currentU, error in
            if let error = error {
                completion(false, error)
            }
            
            if let currentU = currentU {
                
                let gameUID = UUID().uuidString
                
                self.dataBase
                    .collection("currentGames")
                    .document(gameUID)
                    .setData([
                        "ready": [
                            friend.uid: false,
                            currentU.uid: false
                        ],
                        "genres" : [],
                        "formats": [],
                        "seasons": [],
                    ]) { error in
                        completion(false, error)
                    }
                
                self.dataBase
                    .collection("currentGames")
                    .document(gameUID)
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
                    .document(gameUID)
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
                        }
                    }
                
                
                
                self.dataBase.collection("users").document(currentU.uid).collection("currentGameUID").document(friend.uid).setData(["uid" : gameUID]) { error in
                    if let error = error {
                        completion(false, error)
                    }
                }
                
                self.dataBase.collection("users").document(friend.uid).collection("currentGameUID").document(friend.uid).setData(["uid": gameUID]) { error in
                    if let error = error {
                        completion(false, error)
                    }
                }
                
                self.dataBase.collection("users").document(currentU.uid).collection("GameInvFrom").document(friend.uid).delete { error in
                    if let error = error {
                        completion(false, error)
                    }  else {
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
