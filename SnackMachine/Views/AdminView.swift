import SwiftUI

struct AdminView<Unit : Currency> : View {
    
    @State private var isAuthenticated = false
    @State private var total : Decimal = 0.00
    
    var body: some View {
        if isAuthenticated {
            List {
                LabeledContent("Total Change:") {
                    Text(total.toCurrency("GBP"))
                }
                .font(.title)
                AdminChangeView<Unit>(total: $total)
                AdminSnackView()
            }
        }
        else {
            AuthView(isAuthenticated: $isAuthenticated)
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView<Coin>()
    }
}
