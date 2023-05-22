//
//  SearchBar.swift
//  Messenger
//
//  Created by Patryk Maciąg on 12/05/2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var userInput: String
    @Binding var isUsed: Bool
    
    init(userInput: Binding<String>, isUsed: Binding<Bool>) {
        self._userInput = userInput
        self._isUsed = isUsed
    }
    
    var body: some View {
        HStack{
            HStack(spacing: 5){
                ZStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black.opacity(0.4))
                }
                .frame(width: 30)
                TextField("Search...", text: $userInput)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .foregroundColor(.black.opacity(0.4))
                    .disabled(!isUsed)
            }
            .frame(height: 40)
            .background(content: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.4))
                    .shadow(color: .black.opacity(0.2), radius: 1)
            })
            
            if(isUsed){
                Button("Cancel"){
                    isUsed = false
                    userInput = ""
                }
                .foregroundColor(.black.opacity(0.5))
            }
        }
        .padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(userInput: .constant("Search"), isUsed: .constant(true))
    }
}
