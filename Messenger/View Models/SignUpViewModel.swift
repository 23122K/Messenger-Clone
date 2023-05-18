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
    
    
    func signUp() {
        model.signUp(email: emailAddress, password: password, firstName: firstName, lastName: lastName)
    }
}
