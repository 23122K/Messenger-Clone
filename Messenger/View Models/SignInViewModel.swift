import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Injected(\.model) var model
    
    //MARK: Input
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    
    var isValid: Bool {
        let isValidEmail = Validator.isValidMail(email)
        let isValidPassword = Validator.isValidPassword(password)
        if(isValidEmail && isValidPassword){
            return true
        }
        return false
    }
    
    var error: (occured: Bool, description: String) {
        if let error = model.error {
            return(true, error.localizedDescription)
        }
        
        return (false, "")
    }
    
    func signIn() {
        model.signIn(email: email, password: password)
    }
    
    init(){
        model.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
}
