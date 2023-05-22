//
//  ChatListView().swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var vm: ViewModel
    @State var shouldShowLogOutOptions = false
    @State var text: String = ""
    @State var isClicked: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                if(!isClicked){
                    NavigationBar()
                        .animation(.easeIn(duration: 5), value: isClicked)
                        .onAppear{
                            vm.fetchChats()
                        }
                }
                ScrollView(showsIndicators: false, content: {
                    SearchBar(userInput: $text, isUsed: $isClicked)
                        .onTapGesture {
                            isClicked = true
                        }
                        .onSubmit {
                            vm.searchUser(name: text)
                        }
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack{
                            ForEach(vm.chats){ user in
                                NavigationLink(destination: ChatView(user: user).withDismissName(title: "\(user.firstName) \(user.lastName)"), label: {
                                    Bubble(user: user)
                                        .padding(.trailing)
                                })
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                    })
                    switch isClicked {
                    case true:
                        ForEach(vm.listOfUsers){ user in
                            NavigationLink(destination: ChatView(user: user).withDismissName(title: "\(user.firstName) \(user.lastName)"), label: {
                                MessageView(user: user)
                                    .padding(.trailing)
                            })
                        }
                    case false:
                        ForEach(vm.chats){ user in
                            NavigationLink(destination: ChatView(user: user).withDismissName(title: "\(user.firstName) \(user.lastName)"), label: {
                                MessageView(user: user)
                                    .padding(.trailing)
                            })
                        }
                    }
                })
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .environmentObject(ViewModel())
    }
}
