//
//  ViewModel.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import Foundation
import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Injected(\.model) var model
    var cancellables = Set<AnyCancellable>()
    
    var isAuthenticated: Bool {
        model.isAuthenticated
    }
    
    var user: String{
        model.user!.uid
    }
    
    var messages: Array<Message> {
        model.messages
    }
    
    var listOfUsers: Array<UserData> {
        model.userFriends
    }
    
    var userData: UserData {
        guard let user = model.userData else {
            return UserData(firstName: "John", lastName: "Doe")
        }
        return user
    }
    
    func signOut() {
        model.signOut()
    }
    
    func searchUser(name: String) {
        model.searchUser(name: name)
    }
    
    init() {
        model.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send()}
            .store(in: &cancellables)
        
        model.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send()}
            .store(in: &cancellables)
        
        model.$userData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send()}
            .store(in: &cancellables)
        
        model.$userFriends
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send()}
            .store(in: &cancellables)
        
        model.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send()}
            .store(in: &cancellables)
        
    }

}
