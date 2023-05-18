//
//  SignUpView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State var isPresented = false
    @StateObject var vm = SignUpViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sign up")
            TextField("Name", text: $vm.firstName)
            Divider()
            TextField("Surrname", text: $vm.lastName)
            Divider()
            TextField("Email", text: $vm.emailAddress)
            Divider()
            TextField("Password", text: $vm.password)
            Button("Register"){
                vm.signUp()
            }
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            ImagePicker(image: $vm.image)
        })
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
