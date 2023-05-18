//
//  CustomSecureField.swift
//  Messenger
//
//  Created by Patryk Maciąg on 18/05/2023.
//

import SwiftUI

struct CustomSecureField: View {
    let placeholder: String
    let corners: UIRectCorner
    @Binding var text: String
    var body: some View {
        HStack(spacing: 5){
            SecureField(placeholder, text: $text)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .foregroundColor(.black.opacity(0.4))
        }
        .padding(.horizontal)
        .frame(height: 50)
        .background(content: {
            Rectangle()
                .fill(.white.opacity(0.4))
                .shadow(color: .black.opacity(0.1), radius: 1)
                .cornerRadius(20, corners: corners)
        })
        .padding(.horizontal)
    }
}

struct CustomSecureField_Previews: PreviewProvider {
    static var previews: some View {
        CustomSecureField(placeholder: "Email", corners: [.topRight, .topLeft], text: .constant("123123123"))
    }
}
