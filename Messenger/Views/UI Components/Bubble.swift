//
//  BubbleView.swift
//  Messanger
//
//  Created by Patryk Maciąg on 18/05/2023.
//

import SwiftUI

struct Bubble: View {
    let user: ChatUser
    var body: some View {
        VStack(spacing: 1){
            if let image = user.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
            }
            Text(user.firstName)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.black)
            Text(user.lastName)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.black)
                .offset(y: -5)
        }
    }
}

struct Bubble_Previews: PreviewProvider {
    static var previews: some View {
        Bubble(user: ChatUser(firstName: "Patryk", lastName: "Maciag", imageURL: nil))
    }
}
