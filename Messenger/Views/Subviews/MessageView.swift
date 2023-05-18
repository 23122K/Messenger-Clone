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
            Circle()
                .frame(width: 65, height: 65)
            
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.system(size: 22))
                HStack(spacing: 1){
                    Text("I tak musze iść na ten wykład po")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.lightGray))
                    Image(systemName: "circle.fill")
                        .font(.system(size: 2))
                        .foregroundColor(Color(.lightGray))
                    Text("Wed")
                        .font(.system(size: 15))
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
