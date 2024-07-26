import SwiftUI
import Resolver

struct AdminSnackView: View {
    
    @StateObject private var viewModel : AdminSnackViewModel
    
    init(viewModel: AdminSnackViewModel = Resolver.resolve()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Section("Snack Price") {
            Grid(alignment: .leading) {
                ForEach(Array(zip(viewModel.snacks.indices, viewModel.snacks)), id: \.0) { index, snack in
                    SnackGridRow(snack: $viewModel.snacks[index], action: viewModel.updatePrice)
                }
            }
        }
    }
}

extension AdminSnackView {
    
    struct SnackGridRow : View {
        
        @Binding var snack : Snack
        @State var value : String = ""
        
        var action : (Snack, Decimal) -> ()
        
        var body: some View {
            GridRow {
                Text(snack.name)
                    .backgroundStyle(.black)
                    .frame(width: 100, alignment: .leading)
                Text(snack.price.toCurrency("GBP"))
                    .frame(width: 50, alignment: .leading)
                HStack {
                    Spacer()
                    Text("£").multilineTextAlignment(.trailing)
                    TextField("0.00", text: $value)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width:60)
                        .multilineTextAlignment(.trailing)
                }
                .frame(width: 110)
                Spacer()
                Button {
                    if let value = Decimal(string: value), value > 0.00 {
                        action(snack, value)
                    }
                } label: {
                    HStack{
                        Image(systemName: "arrow.clockwise.circle.fill")
                    }
                }.buttonStyle(.plain).foregroundColor(.blue)
            }
        }
    }
}




struct SnackAdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminSnackView()
    }
}
