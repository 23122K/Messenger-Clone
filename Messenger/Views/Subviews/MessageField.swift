//
//  MessageField.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct MessageField: View {
    @State var content: String = ""
    @State var isActive: Bool = false
    
    var body: some View {
        HStack(spacing: 5){
            TextField("Aa", text: $content)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .foregroundColor(.black.opacity(0.4))
                .disabled(!isActive)
            ZStack{
                Image(systemName: "poweroutlet.type.h.fill")
                    .foregroundColor(.black.opacity(0.4))
            }
            .frame(width: 30)
        }
        .padding(.horizontal)
        .frame(height: 40)
        .background(content: {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.4))
                .shadow(color: .black.opacity(0.2), radius: 1)
        })
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField()
    }
}
