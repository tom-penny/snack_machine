import SwiftUI
import Resolver

struct AdminChangeView<Unit : Currency>: View {
        
    @StateObject private var viewModel : AdminChangeViewModel<Unit>
    
    @Binding var total : Decimal
    
    init(viewModel: AdminChangeViewModel<Unit> = Resolver.resolve(), total: Binding<Decimal>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._total = total
    }

    var body: some View {
        Section("Change Quantity") {
            Grid(alignment: .leading) {
                ForEach(Array(zip(viewModel.units.indices, viewModel.units)), id: \.0) { index, unit in
                    ChangeGridRow(unit: $viewModel.units[index], action: viewModel.increaseQuantity)
                }
            }
        }
        .onAppear() {
            self.total = viewModel.total
        }
        .onReceive(viewModel.$units) { _ in
            self.total = viewModel.total
        }
    }
}

extension AdminChangeView {
 
    struct ChangeGridRow<Unit : Currency> : View {
        
        @Binding var unit : Unit
        @State var value : String = ""
        
        var action : (Unit, Int) -> ()
        
        var body: some View {
            GridRow {
                Text(unit.text)
                    .backgroundStyle(.black)
                    .frame(width: 100, alignment: .leading)
                Text("\(unit.quantity)")
                    .frame(width: 50, alignment: .leading)
                HStack {
                    Spacer()
                    Text("QTY").multilineTextAlignment(.trailing)
                    TextField("0", text: $value)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width:60)
                        .multilineTextAlignment(.trailing)
                }
                .frame(width: 110)
                Spacer()
                Button {
                    if let value = Int(value), value > 0 {
                        action(unit, value)
                    }
                } label: {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                        
                    }
                }.buttonStyle(.plain).foregroundColor(.blue)
            }
        }
    }
}

struct ChangeAdminView_Previews: PreviewProvider {
    @State static var total : Decimal = 0.00
    
    static var previews: some View {
        AdminChangeView<CurrencyType>(total: ChangeAdminView_Previews.$total)
    }
}
