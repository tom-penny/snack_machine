import SwiftUI
import Resolver

struct CustomerChangeView<Unit : Currency>: View {

    @StateObject private var viewModel : CustomerChangeViewModel<Unit>

    private var handleClick : (Unit) -> ()

    init(viewModel: CustomerChangeViewModel<Unit> = Resolver.resolve(), handleClick: @escaping (Unit) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.handleClick = handleClick
    }

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(viewModel.units, id: \.self) { unit in
                    Button(unit.text) {
                        handleClick(unit)
                        viewModel.insertUnit(unit)
                    }
                    .buttonStyle(CoinButtonStyle())
                }
            }
        }
    }
}

struct ChangeCustomerView_Previews: PreviewProvider {
    @State static var total : Decimal = 0.00
    
    static var previews: some View {
        CustomerChangeView<CurrencyType> { _ in }
    }
}
