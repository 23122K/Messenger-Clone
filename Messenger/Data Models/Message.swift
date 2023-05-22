//
//  Message.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var content: String
    var sentBy: String
    var sentAt: Date
    var isSender: Bool = false
    
    init(content: String, sentBy: String, sentAt: Date, isSender: Bool = false) {
        self.content = content
        self.sentBy = sentBy
        self.sentAt = sentAt
        self.isSender = isSender
    }
    
    enum CodingKeys: CodingKey {
        case id
        case content
        case sentBy
        case sentAt
    }
}
