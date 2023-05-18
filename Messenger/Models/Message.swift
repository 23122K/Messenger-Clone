//
//  Message.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var content: String
    var from: String
    var to: String
    var timestamp: Date
    var isSender: Bool = false
    
    enum CodingKeys: CodingKey {
        case id
        case content
        case from
        case to
        case timestamp
    }
}


