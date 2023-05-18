//
//  MessageBubble.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    @State private var showTime = false
    var body: some View {
        VStack(alignment: message.isSender ? .trailing : .leading){
            HStack{
                Text(message.content)
                    .padding(10)
                    .background(message.isSender ? Color.gray : Color.purple.opacity(0.5))
                    .cornerRadius(14)
            }
            .frame(maxWidth: 300, alignment: message.isSender ? .trailing : .leading)
            .animation(Animation.spring(), value: showTime)
            .onTapGesture {
                showTime.toggle()
            }
            
            if(showTime){
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.isSender ? .trailing : .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isSender ? .trailing : .leading)
        .padding(5)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(content: "Heelo", from: "me", to: "not me", timestamp: Date()))
    }
}
