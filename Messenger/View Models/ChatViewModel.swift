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
        model.fetchMessages(sendTo: to)
    }
    
    func sendMessage(content: String, sendTo: String){
        model.sendMessage(content: content, sendTo: sendTo)
    }
}
