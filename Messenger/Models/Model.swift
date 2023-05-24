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
    @Published var userData: ChatUser?
    @Published var userFriends = Array<ChatUser>()
    @Published var messages = Array<Message>()
    @Published var chats = Array<ChatUser>()
    
    @Published var error: Error? 
    
    //MARK: AuthenticationService functions
    func signIn(email: String, password: String) {
        authenticationService.signIn(email: email, password: password)
            .sink(receiveCompletion: { [self] completion in
                switch(completion){
                case .failure(let error):
                    self.error = error
                case .finished:
                    firestoreManager.getChatUser(user: self.user)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        authenticationService.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
            .sink(receiveCompletion: { [self] completion in
            switch(completion){
            case .failure(let error):
                self.error = error
            case .finished:
                let user = ChatUser(firstName: firstName, lastName: lastName, imageURL: nil)
                firestoreManager.setChatUser(data: user, user: self.user)
                firestoreManager.getChatUser(user: self.user)
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
                var users = Array<ChatUser>()
                for document in documents {
                    let user = try? document.data(as: ChatUser.self)
                    if let user = user {
                        users.append(user)
                    }
                }
                self.userFriends = users
                
            })
            .store(in: &cancellables)
    }
    
    func sendMessage(content: String, sendTo: String){
        guard let uid = user?.uid else {
            return
        }
        
        firestoreManager.sendMessage(content, sendBy: uid, sendTo: sendTo)
    }
    
    func fetchChats() {
        guard let uid = user?.uid else {
            return
        }

        firestoreManager.fetchChats(sendBy: uid)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished: ()
                }
            }, receiveValue: { querySnapshot in
                for document in querySnapshot.documents {
                    if(!self.userChats.contains(document.documentID)){
                        let message = try? document.data(as: Message.self)
                        if let message = message {
                            print(message.content)
                            self.chatsToReadableChat(user: document.documentID, message: message)
                            
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    private func appendChatUser(chat user: ChatUser){
        if let index = self.chats.firstIndex(where: {$0.unwrapedId == user.unwrapedId}) {
            self.chats.remove(at: index)
            self.chats.insert(user, at: index)
        } else {
            self.chats.append(user)
        }
    }
    
    //Transforms an user ID to user data, than appends data to an array.
    private func chatsToReadableChat(user: String, message: Message) {
        firestoreManager.fetchUser(uid: user)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished: ()
                }
            }, receiveValue: { chatUser in
                var user = chatUser
                user.message = message
                self.appendChatUser(chat: user)
                self.fetchImage(of: user)
            })
            .store(in: &cancellables)
    }

    //Fetches messages in realtime
    //Completion is absolute as listener never emits it
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
            return
        }
        
        firebasestorageManager.persistImage(image: image, uid: uid)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    if let url = self.url?.absoluteString {
                        self.firestoreManager.setImage(imageURL: url, uid: uid)
                    }
                }
            }, receiveValue: { url in
                self.url = url
            })
            .store(in: &cancellables)
        
    }
    
    //MARK: Other
    func fetchImage(of user: ChatUser) {
        guard let imageURL = user.imageURL, let url = URL(string: imageURL) else {
            self.appendChatUser(chat: user)
            return
        }
        
        var user = user
        URLSession.shared.dataTaskPublisher(for: url)
            .sink(receiveCompletion: { _ in
            },receiveValue: {
                guard let response = $0.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    return
                }
                
                user.image = UIImage(data: $0.data)
                self.appendChatUser(chat: user)
            })
            .store(in: &self.cancellables)
    }
 
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
        
        firestoreManager.$firestoreError
            .assign(to: &$error)
        
    }
    
}
