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

    private var auth: Auth
    private var cancellables = Set<AnyCancellable>()
    private var handle: AuthStateDidChangeListenerHandle?
    
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var userData: ChatUser?
    @Published var authenticationError: Error?
    
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            self.auth.signIn(withEmail: email, password: password)
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
            self.auth.createUser(withEmail: email, password: password)
                .sink(receiveCompletion: { completion in
                    switch completion {
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
    
    func signOut(){
        self.auth.deauthorize()
            .sink(receiveCompletion: { completion in
                switch completion {
                case.failure(let error):
                    self.authenticationError = error
                case.finished:
                    self.user = nil
                    self.isAuthenticated = false
                    self.userData = nil
                }
            }, receiveValue: { _ in})
            .store(in: &self.cancellables)
    }
    
    init() {
        self.auth = Auth.auth()
    }
    
}
