//
//  MessageView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct MessageView: View {
    let user: UserData
    var body: some View {
        HStack(spacing: 16) {
            
            //Change it
            if let url = user.imageURL {
                AsyncImage(url: URL(string: url), content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                }, placeholder: {
                    Circle()
                        .frame(width: 60, height: 60)
                })
            } else {
                Circle()
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading) {
                //Martin Randolph
                Text("\(user.firstName) \(user.lastName)")
                    .font(.system(size: 17, weight: .medium))
                    .tracking(-0.4)
                    .foregroundColor(.black)
                HStack(spacing: 1){
                    Text(user.lastMessage ?? "Loading...")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(.lightGray))
                    Image(systemName: "circle.fill")
                        .font(.system(size: 2))
                        .foregroundColor(Color(.lightGray))
                    Text(user.lastMessageTimestamp?.formatted(.dateTime.hour().minute()) ?? "Loading...")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(.lightGray))
                        .padding(.leading, 5)
                }
            }
            Spacer()

        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(user: UserData(firstName: "Patryk", lastName: "Maciag"))
    }
}
