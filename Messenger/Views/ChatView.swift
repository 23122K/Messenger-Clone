//
//  ChatView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct ChatView: View {
    //It is supposed to be @StateObject wrapper but realtime fetching did not work with it properly 
    @ObservedObject var vm = ChatViewModel()
    
    @State var content: String = ""
    let user: ChatUser
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false) {
                if(vm.messages.count > 0){
                    VStack(spacing: 1){
                        ForEach(Array(vm.messages.enumerated()), id: \.element) { index, message in
                            let info = getMessageBubbleInfo(forIndex: index, messages: vm.messages)
                            MessageBubble(corners: info.coreners, message: message)
                                .padding(info.isEnd ? .bottom : Edge.Set.Element())
                        }
                    }
                } else {
                    EmptyChatView(reciver: user)
                }
            }
            MessageField(vm: vm, user: user, content: $content)
                .onAppear{vm.fetchMessages(to: user.unwrapedId)}
        }
    }
    
    //Determines how to round message cornes
    func getMessageBubbleInfo(forIndex i: Int, messages: [Message]) -> (coreners: UIRectCorner, isEnd: Bool) {
        let messageCount = messages.count
        
        switch (i, messageCount) {
        case (0, _):
            if  messageCount == 1 || messages[i].isSender != messages[i+1].isSender {
                return ([.allCorners], true)
            } else {
                switch(messages[i].isSender){
                case true:
                    return ([.topLeft, .topRight, .bottomLeft], false)
                case false:
                    return ([.topLeft, .topRight, .bottomRight], false)
                }
            }
        case (messageCount - 1, _):
            if messages[i].isSender != messages[i-1].isSender {
                return ([.allCorners], true)
            } else {
                switch(messages[i].isSender){
                case true:
                    return ([.bottomLeft, .bottomRight, .topLeft], false)
                case false:
                    return ([.bottomLeft, .bottomRight, .topRight], false)
                }
            }
        default:
            if messages[i].isSender != messages[i-1].isSender && messages[i].isSender != messages[i+1].isSender {
                return ([.allCorners], true)
            } else if messages[i].isSender != messages[i-1].isSender {
                switch(messages[i].isSender){
                case true:
                    return ([.topLeft, .bottomLeft, .topRight], false)
                case false:
                    return ([.topLeft, .bottomRight, .topRight], false)
                }
            } else if messages[i].isSender != messages[i+1].isSender {
                switch(messages[i].isSender){
                case true:
                    return ([.topLeft, .bottomLeft, .bottomRight], true)
                case false:
                    return ([.topRight, .bottomLeft, .bottomRight], true)
                }
            } else {
                switch(messages[i].isSender){
                case true:
                    return ([.topLeft, .bottomLeft], false)
                case false:
                    return ([.topRight, .bottomRight], false)
                }
            }
        }
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(user: ChatUser(firstName: "Bogdan", lastName: "Maj", imageURL: nil))
    }
}
