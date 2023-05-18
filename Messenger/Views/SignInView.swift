//
//  SignInView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @StateObject var vm = SignInViewModel()
    var body: some View {
        VStack(alignment: .leading) {
    
            Text("Sign in")
            TextField("Username", text: $vm.email)
            Divider()
            TextField("Password", text: $vm.password)
            
            Button("Sign in"){
                vm.signIn()
            }
        }
        .padding()
    }}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
