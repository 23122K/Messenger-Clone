//
//  UserNavigationBar.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct NavigationBar: View {
    var body: some View {
        ZStack{
            HStack{
                Circle()
                    .font(.title)
                    .frame(width: 40, height: 40)
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
    }
}
