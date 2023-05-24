import SwiftUI


class SignUpViewModel: ObservableObject {
    @Injected(\.model) var model
    //MARK: Input
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var image: UIImage?
    @Published var rememberMe: Bool = false
    
    var isActive: Bool {
        return true
    }
    
    func signUp() {
        print("Sign up from SignUpViewModel")
        model.signUp(email: emailAddress, password: password, firstName: firstName, lastName: lastName)
    }
}
