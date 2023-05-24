//
//  EmptyChatView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 18/05/2023.
//

import SwiftUI

struct EmptyChatView: View {
    let reciver: UserData
    var body: some View {
        VStack(alignment: .center){
            Circle()
                .frame(width: 100, height: 100)
            Text("\(reciver.firstName) \(reciver.lastName)")
                .font(.system(size: 22, weight: .semibold))
            Text("You're friends on messneger")
                .font(.system(size: 17, weight: .medium))
                .tracking(-0.4)
            VStack{
                HStack{
                    Circle()
                        .frame(width: 60, height: 60)
                    Circle()
                        .stroke(.white, lineWidth: 5)
                        .background(Circle().fill(.brown))
                        .frame(width: 65, height: 65)
                        .offset(x: -20)
                }
                .padding(.leading, 20)
                Text("Don't be shy, say hi to \(reciver.firstName)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
            }
            Spacer()
        }
    }
}

struct EmptyChatView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyChatView(reciver: UserData(firstName: "Patryk", lastName: "Maciag"))
    }
}

