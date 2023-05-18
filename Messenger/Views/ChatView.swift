//
//  ChatView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var vm = ChatViewModel()
    
    @State var content: String = ""
    let user: UserData
    var body: some View {
        NavigationView(content: {
            VStack{
                ScrollView(showsIndicators: false){
                    ForEach(vm.messages) { message in
                        MessageBubble(message: message)
                    }
                }
                HStack{
                    Image(systemName: "photo")
                    TextField("Aa", text: $content)
                        .padding()
                        .border(.black)
                    Button("Send"){
                        vm.sendMessage(content: content, to: user.unwrapedId)
                    }.buttonStyle(.bordered)
                }
                .padding()
                
            }
            .onAppear{vm.fetchMessages(to: user.unwrapedId)}
        })
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(user: UserData(firstName: "Bogdan", lastName: "Maj"))
    }
}
