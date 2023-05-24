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
        NavigationView(content: {
            ScrollView(showsIndicators: false, content: {
                VStack(spacing: 1){
                    Spacer(minLength: 70)
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .padding()
                    
                    VStack {
                        Text("Log in and immerse")
                        Text("in seamless messaging")
                    }
                    .padding()
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    CustomTextField(placeholder: "Email address", corners: [.topLeft, .topRight], text: $vm.email)
                    CustomSecureField(placeholder: "Password", corners: [.bottomLeft, .bottomRight], text: $vm.password)
                        .padding(.bottom)
                    
                    ErrorMessage(description: vm.error.description, isShown: vm.error.occured)
                    
                    VStack{
                        PrimaryButton(isActive: vm.isValid, content: "Sign in")
                            .disabled(!vm.isValid)
                            .onTapGesture {
                                if(vm.isValid){ vm.signIn() }
                            }
                            .padding(.bottom, 2)
                        NavigationLink(destination: SignUpView()
                            .withDismissName(title: "Sign in"), label: {
                                PrimaryButton(isActive: true, content: "Create new accout")
                                    .padding(.bottom, 20)
                        })
                    }
                    Text("Forgot password?")
                        .foregroundColor(.blue.opacity(0.9))
                    Spacer()
                }
            })
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
