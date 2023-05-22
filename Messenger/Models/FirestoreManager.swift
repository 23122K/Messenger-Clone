//
//  FirestoreManager.swift
//  Messenger
//
//  Created by Patryk Maciąg on 17/05/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine

class FirestoreManager: ObservableObject {
    private var db: Firestore
    
    private var cancellables = Set<AnyCancellable>()
    private var listener: ListenerRegistration?
    
    @Published var userData: UserData?
    
    func setData<T: Codable>(data: T, referance: DocumentReference){
        referance.setData(from: data.self)
            .sink(receiveCompletion: { completion in
                switch completion{
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Data set succesfully")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func updateData(data: [AnyHashable : Any], referance: DocumentReference){
        referance.updateData(data) { error in
            if let error = error {
                print(error)
            } else {
                print("Data updated")
            }
        }
    }
    
    func setImage(imageURL: String, uid: String) {
        let data = ["imageURL" : imageURL]
        let referance = db.collection("users").document(uid)
        referance.updateData(data) { error in
            if let error = error{
                print(error)
            }
        }
    }
    
    func setUserData(data: UserData, user: User?){
        guard let uid = user?.uid else {
            print("User not logged in")
            return
        }
        
        let referance = db.collection("users").document(uid)
        setData(data: data, referance: referance)
        print("Data set succesflully")
    }
    
    func getUserData(user: User?){
        guard let uid = user?.uid else {
            print("User not looged in")
            return
        }
        
        let ref = db.collection("users").document(uid)
        
        ref.getDocument()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .failure(let error):
                    print(error)
                case .finished:
                    print("User data fetched succesfully")
                }
            }, receiveValue: { snapshotData in
                self.userData = self.decodeDocumentSnapshot(document: snapshotData)
            })
            .store(in: &cancellables)
    }
    
    func fetchUser(uid: String) -> AnyPublisher<UserData, Error>{
        print("ON 1")
        let referance = db.collection("users").document(uid)
        return Future<UserData, Error> { promise in
            referance.getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error whie fetching user data")
                    promise(.failure(error))
                } else if let snapshot = documentSnapshot {
                    print("ON 2")
                    let user = self.decodeDocumentSnapshot(document: snapshot)
                    print(user)
                    if let user = user {
                        promise(.success(user))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func decodeDocumentSnapshot(document snapshot: DocumentSnapshot) -> UserData?{
        let result = Result { try snapshot.data(as: UserData.self)}
        switch(result){
        case .failure(_):
            return nil
        case .success(let userData):
            return userData
        }
    }
    
    
    //Yet another inconvinience, we cannot make query like "fistname" LIKE %searchTerm%
    func searchUser(name: String) -> AnyPublisher<QuerySnapshot?, Error>{
        return Future<QuerySnapshot?, Error> { promise in
            self.db.collection("users")
                .whereField("firstName", isGreaterThanOrEqualTo: name.lowercased())
                .whereField("firstName", isLessThanOrEqualTo: name.lowercased() + "\u{f8ff}")
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(snapshot))
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    

    func sendMessage(_ message: String, sendBy: String, sendTo: String) {
        let messageData = Message(content: message, sentBy: sendBy, sentAt: Date())
        
        //Chats
        var reciverChatReferance = self.db.collection("chats").document(sendTo).collection("with").document(sendBy)
        var sederChatReferance = self.db.collection("chats").document(sendBy).collection("with").document(sendTo)
    
        self.setData(data: messageData, referance: sederChatReferance)
        self.setData(data: messageData, referance: reciverChatReferance)
        
        reciverChatReferance = self.db.collection("chats").document(sendTo).collection("with").document(sendBy).collection("messages").document()
        sederChatReferance = self.db.collection("chats").document(sendBy).collection("with").document(sendTo).collection("messages").document()
        
        //Last message send
        self.setData(data: messageData, referance: reciverChatReferance)
        self.setData(data: messageData, referance: sederChatReferance)
    }
    
    func fetchMessages(sendTo: String, sendBy: String) -> AnyPublisher<QuerySnapshot, Error>{
        self.db.collection("chats").document(sendBy).collection("with").document(sendTo).collection("messages")
            .snapshotPublisher()
            .eraseToAnyPublisher()
    }
    
    func fetchChats(sendBy: String) -> AnyPublisher<QuerySnapshot, Error>{
        self.db.collection("chats").document(sendBy).collection("with")
            .snapshotPublisher()
            .eraseToAnyPublisher()
    }
    
    init() {
        self.db = Firestore.firestore()
    }
}
