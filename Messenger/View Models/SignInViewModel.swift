import SwiftUI

class SignInViewModel: ObservableObject {
    @Injected(\.model) var model
    
    //MARK: Input
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn() {
        model.signIn(email: email, password: password)
    }
}
