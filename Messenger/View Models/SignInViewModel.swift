import SwiftUI

class SignInViewModel: ObservableObject {
    @Injected(\.model) var model
    
    //MARK: Input
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    
    
    var isValid: Bool {
        if(email != "" && password != ""){
            return true
        }
        return false
    }
    
    func signIn() {
        model.signIn(email: email, password: password)
    }
}
