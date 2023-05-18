//
//  PrimaryButton.swift
//  Messenger
//
//  Created by Patryk Maciąg on 18/05/2023.
//

import SwiftUI

struct PrimaryButton: View {
    let isActive: Bool
    let content: String
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            Text(content)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))
                .padding()
            Spacer()
        }
        .frame(height: 60)
        .background(content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(isActive ? Color.blue.opacity(0.75) : Color.black.opacity(0.15) )
                .shadow(color: .black.opacity(0.2), radius: 1)
        })
        .padding(.horizontal)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(isActive: false, content: "Sign in")
    }
}
