import SwiftUI
import Resolver

struct CustomerView<Unit : Currency> : View {
    
    @StateObject private var viewModel : CustomerViewModel<Unit>
    @State private var transaction: Transaction?
    @State private var error: Error?
    
    init(viewModel: CustomerViewModel<Unit> = Resolver.resolve()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            VStack {
                self.infoScreen
                CustomerSnackView(selection: $viewModel.selection)
                    .padding(30)
                    .padding(.bottom, 20)
            }
            .background(.black)
            CustomerChangeView(handleClick: viewModel.insertUnit)
                .padding(30)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .sheet(item: self.$transaction) {
            viewModel.result = nil
        } content: { transaction in
            displayReceipt(transaction)
        }
        .localErrorAlert(self.$error) {
            viewModel.result = nil
        }
        .onReceive(viewModel.$result) { result in
            switch result {
            case .success(let transaction):
                self.transaction = transaction
            case.failure(let error):
                self.error = error
            case .none:
                self.transaction = nil
                self.error = nil
            }
        }
    }
    
    private var infoScreen: some View {
        VStack {
            Spacer()
            Text(viewModel.selection == nil ? "Make selection" : "Selected \(viewModel.selection!.name)")
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
            Text(viewModel.remaining.toCurrency())
                .font(.system(size: 50, weight: .semibold, design: .monospaced))
        }
        .foregroundStyle(.ultraThickMaterial)
    }
}

extension CustomerView {
    
    private func displayReceipt(_ transaction: Transaction) -> some View {
        VStack {
            Text("SALE COMPLETE")
                .font(.title)
            Grid(alignment: .leading, horizontalSpacing: 100, verticalSpacing: 10) {
                GridRow {
                    Text(transaction.snack.name)
                    Text(transaction.total.toCurrency("GBP"))
                        .gridColumnAlignment(.trailing)
                }
                Divider().gridCellUnsizedAxes(.horizontal)
                GridRow {
                    Text("Cash:")
                    Text(transaction.cash.toCurrency("GBP"))
                        .gridColumnAlignment(.trailing)
                }
                Divider().gridCellUnsizedAxes(.horizontal)
                GridRow {
                    Text("Change:")
                    Text(transaction.change.toCurrency("GBP"))
                        .gridColumnAlignment(.trailing)
                }
            }
            .padding()
            if transaction.change > 0.00 {
                Grid(horizontalSpacing: 50, verticalSpacing: 10) {
                    GridRow {
                        Text("YOUR CHANGE")
                            .gridCellColumns(3)
                    }
                    Divider().gridCellUnsizedAxes(.horizontal)
                    ForEach(transaction.tally.sorted(by: >), id: \.key) { unit, quantity in
                        GridRow {
                            Text(unit)
                                .gridColumnAlignment(.leading)
                            Text("x")
                                .gridColumnAlignment(.center)
                            Text("\(quantity)")
                                .gridColumnAlignment(.trailing)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView<CurrencyType>()
    }
}
