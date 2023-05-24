//
//  CustomAlert.swift
//  Messenger
//
//  Created by Patryk Maciąg on 24/05/2023.
//

import SwiftUI

struct ErrorMessage: View {
    let description: String
    let isShown: Bool
    var body: some View {
        if isShown {
            VStack{
                Text("Error occured")
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
            }
            .padding()
        }
    }
}

struct ErrorMessage_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessage(description: "Test", isShown: true)
    }
}
