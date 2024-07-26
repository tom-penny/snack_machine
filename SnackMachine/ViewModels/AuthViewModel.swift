import SwiftUI

class AuthViewModel : ViewModel {
    
    private let pin = "0"
    private let password = "0"
    
    @Published var error : Error?
        
    var errorRaised: Binding<Bool> {
        Binding<Bool> {
            self.error != nil
        } set: { newValue in
            guard !newValue else { return }
            self.error = nil
        }
    }
    
    func authenticate(pin: String, password: String) -> Bool {
        switch (pin == self.pin, password == self.password) {
        case (false, _):
            self.error = LocalError.wrongPin
            return false
        case (_, false):
            self.error = LocalError.wrongPassword
            return false
        case (true, true):
            return true
        }
    }
}

extension AuthViewModel {
    
    enum LocalError : LocalizedError {
        
        case wrongPin
        case wrongPassword
        
        var errorDescription: String? {
            switch self {
            case .wrongPin:
                return "Wrong pin"
            case .wrongPassword:
                return "Wrong password"
            }
        }
            
        var recoverySuggestion: String? {
            switch self {
            case .wrongPin:
                return "Re-enter pin"
            case .wrongPassword:
                return "Re-enter password"
            }
        }
    }
}
