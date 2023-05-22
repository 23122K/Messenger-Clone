//
//  MessageBubble.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct MessageBubble: View {
    let corners: UIRectCorner
    let message: Message
    @State private var showTime = false

    init(corners: UIRectCorner = [], message: Message, showTime: Bool = false) {
        self.corners = corners
        self.message = message
        self.showTime = showTime
    }
    
    var body: some View {
        VStack(alignment: message.isSender ? .trailing : .leading){
            HStack{
                Text(message.content.count > 2 ? message.content : " \(message.content) ")
                    .padding(10)
                    .foregroundColor(message.isSender ? .white : .black)
                    .background(message.isSender ? Color.blue.opacity(0.8) : Color.gray.opacity(0.12))
                    .cornerRadius(7)
                    .cornerRadius(20, corners: corners)
            }
            .frame(maxWidth: 300, alignment: message.isSender ? .trailing : .leading)
            .animation(Animation.spring(), value: showTime)
            .onTapGesture {
                showTime.toggle()
            }
            
            if(showTime){
                Text("\(message.sentAt.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.isSender ? .trailing : .leading)
                    .animation(Animation.easeInOut(duration: 5), value: showTime)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isSender ? .trailing : .leading)
        .padding(.horizontal, 5)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(content: "Hello from the other side", sentBy: "me", sentAt: Date(), isSender: false))
    }
}
