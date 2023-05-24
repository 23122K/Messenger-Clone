import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Injected(\.model) var model
    
    //MARK: Input
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var image: UIImage?
    @Published var rememberMe: Bool = false
    
    var error: (occured: Bool, description: String) {
        if let error = model.error {
            return(true, error.localizedDescription)
        }
        
        return (false, "")
    }
    
    var isActive: Bool {
        let isValidPassword = Validator.isValidPassword(password)
        let isValidConfirmPassword = Validator.isValidPassword(confirmPassword)
        let isValidEmail = Validator.isValidMail(emailAddress)
        
        let isValidName = Validator.isValidString(firstName)
        let isValidSurname = Validator.isValidString(lastName)
        
        if isValidName && isValidSurname && isValidPassword && isValidConfirmPassword && isValidEmail {
            return true
        }
        
        return false
    }

    func signUp() {
        model.signUp(email: emailAddress, password: password, firstName: firstName, lastName: lastName)
    }
    
    init(){
        model.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
}
