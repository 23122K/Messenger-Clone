//
//  BubbleView.swift
//  Messanger
//
//  Created by Patryk Maciąg on 18/05/2023.
//

import SwiftUI

struct Bubble: View {
    let user: UserData
    var body: some View {
        VStack(spacing: 1){
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
        Bubble(user: UserData(firstName: "Patryk", lastName: "Maciag", imageURL: nil))
    }
}
