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
                    UserNavigationBar()
                        .animation(.easeIn(duration: 5), value: isClicked)
                }
                ScrollView {
                    VStack {
                        SearchBar(userInput: $text, isUsed: $isClicked)
                            .onTapGesture {
                                isClicked = true
                            }
                            .onSubmit {
                                vm.searchUser(name: text)
                            }
                        ForEach(vm.listOfUsers) { user in
                            NavigationLink(destination: ChatView(user: user).withDismissName(title: "\(user.firstName) \(user.lastName)"), label: {
                                MessageView(user: user)
                                    .animation(Animation.spring())
                            })
                        }
                        Spacer()
                    }
                }
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
