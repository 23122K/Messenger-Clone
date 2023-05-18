//
//  AuthenticationService.swift
//  Messenger
//
//  Created by Patryk Maciąg on 17/05/2023.
//

import Combine
import Foundation
import Firebase
import FirebaseAuthCombineSwift

class AuthenticationService: ObservableObject {

    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var userData: UserData? 
    
    private var cancellables = Set<AnyCancellable>()
    private var handle: AuthStateDidChangeListenerHandle?
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password)
                .sink(receiveCompletion: { completion in
                    switch(completion) {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        self.isAuthenticated = true
                        promise(.success(()))
                    }
                }, receiveValue: { authDataResult in
                    self.user = authDataResult.user
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) -> AnyPublisher<Void, Error>{
        return Future<Void, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        self.isAuthenticated = true
                    }
                }, receiveValue: { authDataResult in
                    self.user = authDataResult.user
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func signOut(){
        Auth.auth().deauthorize()
            .sink(receiveCompletion: { completion in
                switch completion {
                case.failure(let error):
                    print(error)
                case.finished:
                    self.user = nil
                    self.isAuthenticated = false
                    self.userData = nil
                }
            }, receiveValue: { _ in})
            .store(in: &self.cancellables)
    }
    
}
