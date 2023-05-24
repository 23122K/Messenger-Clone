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
    
    @Published var image: UIImage?
    
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
            return UserData(firstName: "John", lastName: "Doe", imageURL: nil)
        }
        return user
    }
    
    var chats: Array<UserData> {
        model.chats
    }
    
    func fetchChats(){
        model.fetchChats()
    }
    
    func signOut() {
        model.signOut()
    }
    
    func searchUser(name: String) {
        model.searchUser(name: name)
    }
    
    func persistImage(){
        guard let image = image else {
            print("NO image")
            return
        }
        model.saveUserImage(image: image)
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
        
        model.$chats
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in self?.objectWillChange.send()}
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
