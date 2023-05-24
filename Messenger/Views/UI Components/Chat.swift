//
//  Chat.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct Chat: View {
    let user: ChatUser
    let showDetails: Bool
    
    init(user: ChatUser, showDetails: Bool = true) {
        self.user = user
        self.showDetails = showDetails
    }
    
    var body: some View {
        HStack(spacing: 16) {
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
            VStack(alignment: .leading) {
                //Martin Randolph
                Text("\(user.firstName) \(user.lastName)")
                    .font(.system(size: 17, weight: .medium))
                    .tracking(-0.4)
                    .foregroundColor(.black)
                if showDetails {
                    HStack(spacing: 1){
                        Text(user.message?.content ?? "Loading...")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(.lightGray))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Image(systemName: "circle.fill")
                            .font(.system(size: 2))
                            .foregroundColor(Color(.lightGray))
                        Text(formatDate(user.message?.sentAt))
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(.lightGray))
                            .padding(.leading, 5)
                        Spacer()
                    }
                }
            }
            Spacer()

        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    func formatDate(_ sentAt: Date?) -> String {
        guard let sentAt = sentAt else {
            return "Loading..."
        }
        
        let calendar = Calendar.current
        let now = Date()
        let formatter = DateFormatter()
        
        switch sentAt {
        case _ where calendar.isDateInToday(sentAt):
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: sentAt)
        case _ where calendar.isDateInYesterday(sentAt):
            formatter.dateFormat = "EEEE"
            return "\(formatter.string(from: sentAt))"
        case _ where calendar.isDate(sentAt, equalTo: now, toGranularity: .month):
            formatter.dateFormat = "MMMM"
            return "\(formatter.string(from: sentAt))"
        default:
            formatter.dateFormat = "MMMM"
            return "\(formatter.string(from: sentAt))"
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat(user: ChatUser(firstName: "Patryk", lastName: "Maciag"))
    }
}
