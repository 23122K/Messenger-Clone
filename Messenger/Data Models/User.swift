//
//  User.swift
//  Messenger
//
//  Created by Patryk Maciąg on 17/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct UserData: Identifiable, Codable {
    @DocumentID var id: String?
    let firstName: String
    let lastName: String
    let imageURL: String?
    var lastMessage: String? = nil
    var lastMessageTimestamp: Date? = nil
    
    
    init(firstName: String, lastName: String, imageURL: String? = nil, lastMessage: String = "", lastMessageTimestamp: Date? = nil ) {
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
    }
    
    enum CodingKeys: CodingKey {
        case id
        case firstName
        case lastName
        case imageURL
    }
    
}

extension UserData {
    var unwrapedId: String {
        return id!
    }
}

