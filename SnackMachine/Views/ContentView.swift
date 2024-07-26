import SwiftUI

struct ContentView<Unit : Currency>: View {
    
    @State private var page = 0
    
    var body: some View {
        TabView(selection: $page) {
            CustomerView<Unit>().tabItem {
                Label("Customer Menu", systemImage: "house.circle.fill")
            }.tag(0)
            AdminView<Unit>().tabItem {
                Label("Admin Menu", systemImage: "lock.circle.fill")
            }.tag(1)
        }
        .tabViewStyle(.page).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<CurrencyType>()
    }
}
