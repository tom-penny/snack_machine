import SwiftUI

extension View {
    
    func localErrorAlert(_ error: Binding<Error?>) -> some View {
        let localError = LocalErrorWrapper(error: error.wrappedValue)
        return alert(isPresented: .constant(localError != nil), error: localError) { _ in
            Button("OK") {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
    
    func localErrorAlert(_ error: Binding<Error?>, onDismiss: @escaping () -> Void?) -> some View {
        let localError = LocalErrorWrapper(error: error.wrappedValue)
        return alert(isPresented: .constant(localError != nil), error: localError) { _ in
            Button("OK") {
                onDismiss()
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
