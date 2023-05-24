import Foundation
import Firebase
import SwiftUI
import FirebaseFirestoreSwift
import Combine

class Model: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var userChats = Array<String>()
    private var url: URL?
    
    //MARK: Dependencies
    private let authenticationService: AuthenticationService
    private let firestoreManager: FirestoreManager
    private let firebasestorageManager: FirebaseStorageManager
    
    //MARK: Properties driving UI
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    @Published var authUser: User?
    @Published var userData: UserData?
    @Published var userFriends = Array<UserData>()
    @Published var messages = Array<Message>()
    @Published var chats = Array<UserData>()
    
    //MARK: AuthenticationService functions
    func signIn(email: String, password: String) {
        authenticationService.signIn(email: email, password: password)
            //Maybe add casting error into a string?
            .sink(receiveCompletion: { [self] completion in
                switch(completion){
                case .failure(let err):
                    print(err)
                case .finished:
                    firestoreManager.getUserData(user: self.user)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        print("Sign up from model")
        authenticationService.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
            .sink(receiveCompletion: { [self] completion in
            switch(completion){
            case .failure(let err):
                print(err)
            case .finished:
                print("Sign up seccesfull")
                let userData = UserData(firstName: firstName, lastName: lastName, imageURL: nil)
                print("Firestoremanager take the rest of the work")
                firestoreManager.setUserData(data: userData, user: self.user)
                firestoreManager.getUserData(user: self.user)
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
    }
    
    
    func signOut() {
        authenticationService.signOut()
    }
    
    
    //MARK: Firestore functions
    func searchUser(name: String) {
        firestoreManager.searchUser(name: name)
            .sink(receiveCompletion: { _ in }, receiveValue: {
                guard let documents = $0?.documents else {
                    return
                }
                
                var users = Array<UserData>()
                for document in documents {
                    let user = try? document.data(as: UserData.self)
                    if let user = user {
                        users.append(user)
                    }
                }
                self.userFriends = users
                
            })
            .store(in: &cancellables)
    }
    
    func sendMessage(content: String, sendTo: String){
        firestoreManager.sendMessage(content, sendBy: user!.uid, sendTo: sendTo)
    }
    
    func fetchChats() {
        print("FETCHING CHATS")
        guard let uid = user?.uid else {
            return
        }

        firestoreManager.fetchChats(sendBy: uid)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err)
                case .finished:
                    print("Finished")
                }
            }, receiveValue: { querySnapshot in
                for document in querySnapshot.documents {
                    if(!self.userChats.contains(document.documentID)){
                        let message = try? document.data(as: Message.self)
                        if let message = message {
                            print(message.content)
                            self.chatsToReadableChat(user: document.documentID, message: message)
                        }
                        //self.userChats.append(document.documentID)
                        //self.chatsToReadableChat()
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    func chatsToReadableChat(user: String, message: Message) {
        firestoreManager.fetchUser(uid: user)
            .print("fetchUser")
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { userData in
                print("ON 2")
                var user = userData
                user.lastMessage = message.content
                user.lastMessageTimestamp = message.sentAt
                if let index = self.chats.firstIndex(where: {$0.unwrapedId == user.unwrapedId}) {
                    self.chats.remove(at: index)
                    self.chats.append(user)
                } else {
                    self.chats.append(user)
                }
            })
            .store(in: &cancellables)
    }

    func fetchMessages(sendTo: String){
        if let sendBy = user?.uid {
            firestoreManager.fetchMessages(sendTo: sendTo, sendBy: sendBy)
                .sink(receiveCompletion: { _ in }, receiveValue: { data in
                    var recivedMessages = Array<Message>()
                    for document in data.documents {
                        let message = try? document.data(as: Message.self)
                        if var message = message {
                            if(message.sentBy == self.user!.uid){
                                message.isSender = true
                            }
                            recivedMessages.append(message)
                        }
                    }
                    self.messages = recivedMessages.sorted(by: {$0.sentAt < $1.sentAt})
                })
                .store(in: &cancellables)
        }
    }
    
    //MARK: Firestorage functions
    
    func saveUserImage(image: UIImage){
        guard let uid = user?.uid else {
            print("No user logged in <saveuserImage>")
            return
        }
        
        firebasestorageManager.persistImage(image: image, uid: uid)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Finished")
                    if let url = self.url?.absoluteString {
                        self.firestoreManager.setImage(imageURL: url, uid: uid)
                    }
                }
            }, receiveValue: { url in
                self.url = url
            })
            .store(in: &cancellables)
        
    }
    //MARK: CoreData functions
    //Maybe in the future
    
    //MARK: Init
    init() {
        self.firebasestorageManager = FirebaseStorageManager()
        self.authenticationService = AuthenticationService()
        self.firestoreManager = FirestoreManager()
        
        //Waching changes in AuthenticationService aka FirebaseAuth
        authenticationService.$isAuthenticated
            .assign(to: &$isAuthenticated)
        
        authenticationService.$user
            .assign(to: &$user)
        
        //Waching changes in FirestoreManager
        firestoreManager.$userData
            .assign(to: &$userData)
        
    }
    
}
