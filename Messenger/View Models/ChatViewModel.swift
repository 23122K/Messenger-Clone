//
//  ChatViewModel.swift
//  Messenger
//
//  Created by Patryk Maciąg on 17/05/2023.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Injected(\.model) var model

    var messages: Array<Message> {
        model.messages
    }
    
    
    func fetchMessages(to: String){
        model.fetchMessages(to: to)
    }
    
    func sendMessage(content: String, to: String){
        model.sendMessage(content: content, to: to)
    }
}
