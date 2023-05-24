//
//  SignUpView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @StateObject var vm = SignUpViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Create your accout")
                .font(.system(size: 25, weight: .bold))
                .padding(.leading)
                .padding(.bottom)
            CustomTextField(placeholder: "First name", corners: [.topLeft, .topRight], text: $vm.firstName)
            CustomTextField(placeholder: "Last name", corners: [.bottomLeft, .bottomRight], text: $vm.lastName)
                .padding(.bottom, 20)
            
            CustomTextField(placeholder: "Email address or phone number", corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], text: $vm.emailAddress)
                .padding(.bottom, 20)
            
            CustomSecureField(placeholder: "Password", corners: [.topLeft, .topRight], text: $vm.password)
            CustomSecureField(placeholder: "Confirm password", corners: [.bottomLeft, .bottomRight], text: $vm.confirmPassword)
                .padding(.bottom, 20)
            
            ErrorMessage(description: vm.error.description, isShown: vm.error.occured)
            
            PrimaryButton(isActive: vm.isActive, content: "Sign up")
                .disabled(!vm.isActive)
                .onTapGesture {
                    if(vm.isActive){
                        vm.signUp()
                    }
                }
            Spacer()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
