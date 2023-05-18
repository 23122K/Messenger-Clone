//
//  UserNavigationBar.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct UserNavigationBar: View {
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "line.3.horizontal")
                .resizable()
                .font(.title)
                .frame(width: 30, height: 25)
                .onTapGesture {
                    vm.signOut()
                }
            Spacer()
            Text("Chats")
                .bold()
                .font(.title2)
            Spacer()
            Image(systemName: "square.and.pencil")
                .bold()
                .font(.title)
        }
        .padding(.horizontal)
        //.border(.red)
    }
}

struct UserNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        UserNavigationBar()
    }
}
