import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class Model: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Dependencies
    private let authenticationService: AuthenticationService
    private let firestoreManager: FirestoreManager
    
    //MARK: Properties driving UI
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    @Published var userData: UserData?
    @Published var userFriends = Array<UserData>()
    @Published var messages = Array<Message>()
    
    //MARK: AuthenticationService functions
    func signIn(email: String, password: String) {
        authenticationService.signIn(email: email, password: password)
            //Maybe add cating error into a string?
            .sink(receiveCompletion: { [self] completion in
                switch(completion){
                case .failure(let err):
                    print(err)
                case .finished:
                    firestoreManager.fetchUserData(user: self.user)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        authenticationService.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
            .sink(receiveCompletion: { [self] completion in
            switch(completion){
            case .failure(let err):
                print(err)
            case .finished:
                firestoreManager.storeUserData(firstName: firstName, lastName: lastName, user: self.user)
                firestoreManager.fetchUserData(user: self.user)
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
    
    func sendMessage(content: String, to: String){
        firestoreManager.sendMessage(content, from: user!.uid, to: to)
    }
    
    func fetchMessages(to: String){
        firestoreManager.fetchMessages(from: user!.uid, to: to)
            .sink(receiveCompletion: { _ in }, receiveValue: { data in
//                guard let documents = data?.documents else {
//                    print("Failes here")
//                    return
//                }
                
                var recivedMessages = Array<Message>()
                for document in data.documents {
                    let message = try? document.data(as: Message.self)
                    if var message = message {
                        if(message.from == self.user!.uid){
                            message.isSender = true
                        }
                        recivedMessages.append(message)
                    }
                }
                let test = recivedMessages.filter{ $0.from == self.user!.uid}
                let recived = recivedMessages.filter{ $0.from != self.user!.uid}
                print("Sent \(test.count) messages")
                print("Recived \(recived.count) messages")
                self.messages = recivedMessages.sorted(by: {$0.timestamp < $1.timestamp})
            })
            .store(in: &cancellables)
    }
    
    //MARK: CoreData functions
    //Maybe in the future
    
    //MARK: Init
    init() {
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
