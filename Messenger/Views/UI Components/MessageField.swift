//
//  MessageField.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct MessageField: View {
    @ObservedObject var vm: ChatViewModel
    let user: UserData
    @Binding var content: String
    @State var isActive: Bool = false
    
    var body: some View {
        HStack(spacing: 25){
            switch isActive {
            case true:
                Image(systemName: "chevron.right")
                    .font(.system(size: 25))
                    .foregroundColor(.blue.opacity(0.9))
                    .onTapGesture {
                        isActive = false
                    }
            case false:
                Image("Camera")
                Image("Photos")
                Image("Microphone")
            }
            HStack(spacing: 5){
                TextField("Aa", text: $content)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .foregroundColor(.black.opacity(0.4))
            }
            .padding(.horizontal)
            .frame(height: 40)
            .background(content: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.4))
                    .shadow(color: .black.opacity(0.2), radius: 1)
            })
            .onTapGesture {
                isActive = true
            }
            
            switch isActive {
            case true:
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        vm.sendMessage(content: content, to: user.unwrapedId)
                    }
            case false:
                Image(systemName: "heart.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.blue.opacity(0.9))
            }
        }
        .padding(.horizontal)
        .onAppear{
            vm.fetchMessages(to: user.unwrapedId)
        }
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField(vm: ChatViewModel(), user: UserData(firstName: "Patryk", lastName: "Maciag"), content: .constant("Hello"))
    }
}
