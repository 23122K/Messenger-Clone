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
    private var listener: ListenerRegistration?
    
    @Published var userData: UserData?
    
    func storeUserData(firstName: String, lastName: String, user: User?) {
        let usersCollection = db.collection("users")
        
        var userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName
        ]
        
        guard let user = user else {
            print("No user found")
            return
        }
        
        let newUserRef = usersCollection.document(user.uid)
        
        
        // Set the user data in the Firestore document
        newUserRef.setData(userData) { error in
            if let error = error {
                print("Error registering user data: \(error.localizedDescription)")
            } else {
                print("User data registered successfully!")
            }
        }
    }
    
    
    func searchUser(name: String) -> AnyPublisher<QuerySnapshot?, Error>{
        return Future<QuerySnapshot?, Error> { promise in
            self.db.collection("users")
                .whereField("firstName", isLessThanOrEqualTo: name + "\u{f8ff}")
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
    
    func sendMessage(_ message: String, from: String, to: String) {
        var document = db.collection("Messages").document(from).collection(to).document()
        
        let messageFrom = ["from": from, "to": to, "content": message, "timestamp": Timestamp()] as [String : Any]
        
        document.setData(messageFrom) { error in
            if let error = error {
                print(error)
            }
        }
        
        document = db.collection("Messages").document(to).collection(from).document()
        document.setData(messageFrom) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /*
     // MARK: - Snapshot Publisher

         /// Registers a publisher that publishes document snapshot changes.
         ///
         /// - Parameter includeMetadataChanges: Whether metadata-only changes (i.e. only
         ///   `DocumentSnapshot.metadata` changed) should trigger snapshot events.
         /// - Returns: A publisher emitting `DocumentSnapshot` instances.
         func snapshotPublisher(includeMetadataChanges: Bool = false)
           -> AnyPublisher<DocumentSnapshot, Error> {
           let subject = PassthroughSubject<DocumentSnapshot, Error>()
           let listenerHandle =
             addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
               if let error = error {
                 subject.send(completion: .failure(error))
               } else if let snapshot = snapshot {
                 subject.send(snapshot)
               }
             }
           return subject
             .handleEvents(receiveCancel: listenerHandle.remove)
             .eraseToAnyPublisher()
         }
     */
    
    func fetchMessages(from: String, to: String) -> AnyPublisher<QuerySnapshot, Error>{
        self.db.collection("Messages").document(from).collection(to)
            .snapshotPublisher()
            .eraseToAnyPublisher()
//        return Future<QuerySnapshot?, Error> { promise in
//            let listener = referance.addSnapshotListener { (snapshot, error ) in
//                if let error = error {
//                    promise(.failure(error))
//                    return
//                } else {
//                    promise(.success(snapshot))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
    }
    
    func fetchUserData(user: User?) {
            guard let currentUser = user else {
                print("XD")
                return
            }
        
            let userRef = db.collection("users").document(currentUser.uid)
            
            userRef.getDocument { [weak self] document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    let firstName = data?["firstName"] as? String ?? ""
                    let lastName = data?["lastName"] as? String ?? ""
                    
                    self?.userData = UserData(firstName: firstName, lastName: lastName)
                } else {
                    print("Document does not exist or there was an error: \(error?.localizedDescription ?? "")")
                }
            }
        }
    
    init() {
        self.db = Firestore.firestore()
    }
}
