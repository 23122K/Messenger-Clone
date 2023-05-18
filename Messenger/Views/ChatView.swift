//
//  ChatView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct ChatView: View {
    //It is supposed to be @StateObject wrapper but realtime fetching did not work when wrapped
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
                MessageField(vm: vm, user: user, content: $content)
                
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
