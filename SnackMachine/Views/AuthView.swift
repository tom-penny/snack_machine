import SwiftUI
import Resolver

struct AuthView: View {
    
    @StateObject private var viewModel : AuthViewModel
    @State private var pin : String = ""
    @State private var password : String = ""

    @Binding var isAuthenticated : Bool
    
    init(viewModel: AuthViewModel = Resolver.resolve(), isAuthenticated: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isAuthenticated = isAuthenticated
    }
    
    var body: some View {
        VStack {
            Text("Admin Login")
                .font(.title)
                .padding()
            LabeledContent {
                SecureField("Pin", text: $pin)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            } label: {
                Image(systemName: "lock.fill")
            }
            .padding(.horizontal, 20)
            LabeledContent {
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
            } label: {
                Image(systemName: "key.fill")
            }
            .padding(.horizontal, 20)
            Button("Submit") {
                self.isAuthenticated = viewModel.authenticate(pin: pin, password: password)
            }
            .padding()
        }
        .padding()
        .localErrorAlert($viewModel.error)
    }
}

struct AuthView_Previews: PreviewProvider {
    
    @State static var isAuthenticated = false
    
    static var previews: some View {
        AuthView(isAuthenticated: AuthView_Previews.$isAuthenticated)
    }
}
