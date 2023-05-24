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
    
    @Published var userData: ChatUser?
    @Published var firestoreError: Error?
    
    func setData<T: Codable>(data: T, referance: DocumentReference){
        referance.setData(from: data.self)
            .sink(receiveCompletion: { completion in
                switch completion{
                case .failure(let error):
                    self.firestoreError = error
                case .finished: ()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func updateData(data: [AnyHashable : Any], referance: DocumentReference){
        referance.updateData(data) { error in
            if let error = error {
                self.firestoreError = error
            }
        }
    }
    
    func setImage(imageURL: String, uid: String) {
        let data = ["imageURL" : imageURL]
        let referance = db.collection("users").document(uid)
        referance.updateData(data) { error in
            if let error = error{
                self.firestoreError = error
            }
        }
    }
    
    func setChatUser(data: ChatUser, user: User?){
        guard let uid = user?.uid else {
            return
        }
        
        let referance = db.collection("users").document(uid)
        setData(data: data, referance: referance)
    }
    
    func getChatUser(user: User?){
        guard let uid = user?.uid else {
            return
        }
        
        let ref = db.collection("users").document(uid)
        
        ref.getDocument()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .failure(let error):
                    self.firestoreError = error
                case .finished: ()
                }
            }, receiveValue: { snapshotData in
                self.userData = self.decodeDocumentSnapshot(document: snapshotData)
            })
            .store(in: &cancellables)
    }
    
    func fetchUser(uid: String) -> AnyPublisher<ChatUser, Error>{
        let referance = db.collection("users").document(uid)
        return Future<ChatUser, Error> { promise in
            referance.getDocument{ documentSnapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = documentSnapshot {
                    let user = self.decodeDocumentSnapshot(document: snapshot)
                    if let user = user {
                        promise(.success(user))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func decodeDocumentSnapshot(document snapshot: DocumentSnapshot) -> ChatUser?{
        let result = Result { try snapshot.data(as: ChatUser.self)}
        switch(result){
        case .failure(_):
            return nil
        case .success(let userData):
            return userData
        }
    }
    
    
    //Advanced queries not for free hm?
    func searchUser(name: String) -> AnyPublisher<QuerySnapshot?, Error>{
        return Future<QuerySnapshot?, Error> { promise in
            self.db.collection("users")
                .whereField("firstName", isEqualTo: name)
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
    

    //Creates a databse structure, duplicates data and assign it to users between conversation take place
    func sendMessage(_ message: String, sendBy: String, sendTo: String) {
        let messageData = Message(content: message, sentBy: sendBy, sentAt: Date())
        
        //Creates a sort of collection for each user about whith whom he has conversation
        var reciverChatReferance = self.db.collection("chats").document(sendTo).collection("with").document(sendBy)
        var sederChatReferance = self.db.collection("chats").document(sendBy).collection("with").document(sendTo)
    
        //Sets latest message
        self.setData(data: messageData, referance: sederChatReferance)
        self.setData(data: messageData, referance: reciverChatReferance)
        
        //Sets messages
        reciverChatReferance = self.db.collection("chats").document(sendTo).collection("with").document(sendBy).collection("messages").document()
        sederChatReferance = self.db.collection("chats").document(sendBy).collection("with").document(sendTo).collection("messages").document()
        
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
