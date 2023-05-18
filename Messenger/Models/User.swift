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
    
}

extension UserData {
    var unwrapedId: String {
        return id!
    }
}
