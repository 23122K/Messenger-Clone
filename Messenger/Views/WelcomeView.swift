//
//  WelcomeView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView(content: {
            VStack{
                NavigationLink("Sign In", destination: SignInView())
                NavigationLink("Sign Up", destination: SignUpView())
            }
        })
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
