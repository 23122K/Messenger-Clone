//
//  UserNavigationBar.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        ZStack{
            HStack{
                NavigationLink(destination: SettingsView().withDismissName(title: "Chats"), label: {
                    if let url = vm.userData.imageURL {
                        AsyncImage(url: URL(string: url), content: { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                        }, placeholder: {
                            Circle()
                                .frame(width: 40, height: 40)
                        })
                    } else {
                        Circle()
                            .frame(width: 40, height: 40)
                    }
                })
                Spacer()
            }
                
            HStack{
                Text("Chats")
                    .bold()
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
            .environmentObject(ViewModel())
    }
}
