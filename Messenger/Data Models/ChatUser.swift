//
//  User.swift
//  Messenger
//
//  Created by Patryk Maciąg on 17/05/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct ChatUser: Identifiable, Codable {
    @DocumentID var id: String?
    let firstName: String
    let lastName: String
    let imageURL: String?
    var message: Message? = nil
    var image: UIImage? = nil
    
    init(firstName: String, lastName: String, imageURL: String? = nil, message: Message? = nil, image: UIImage? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.message = message
        self.image = image
    }
    
    enum CodingKeys: CodingKey {
        case id
        case firstName
        case lastName
        case imageURL
    }
}

extension ChatUser {
    var unwrapedId: String {
        return id!
    }
}

