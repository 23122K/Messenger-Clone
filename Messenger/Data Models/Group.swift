//
//  Group.swift
//  Messenger
//
//  Created by Patryk Maciąg on 21/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Identifiable, Codable {
    @DocumentID var id: String?
    let createdAt: Date
    let createdBy: String
    let members: Array<String>
    
    init(createdAt: Date, createdBy: String, members: Array<String> = Array<String>()){
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.members = members
    }
    
    
}
