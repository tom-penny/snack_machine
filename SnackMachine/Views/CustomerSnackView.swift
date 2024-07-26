import SwiftUI
import Resolver

struct CustomerSnackView: View {
    
    @StateObject private var viewModel : CustomerSnackViewModel

    @Binding var selection : Snack?

    init(viewModel: CustomerSnackViewModel = Resolver.resolve(), selection: Binding<Snack?>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._selection = selection
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 30) {
            ForEach(Array(zip(viewModel.snacks.indices, viewModel.snacks)), id: \.0) { index, snack in
                gridCell(snack: snack, index: index)
            }
        }
    }
    
    private func gridCell(snack: Snack, index: Int) -> some View {
        VStack {
            Image(snack.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .opacity(snack.quantity < 1 ? 0.5 : 1)
                .brightness(snack == selection ? 0 : -0.5)
            if snack.quantity < 1 {
                Text("Out of stock")
                    .foregroundStyle(.thinMaterial)
                    .frame(width: 100, height: 30)
            }
            else {
                Label(snack.price.toCurrency("GBP"), systemImage: snack == selection
                      ?"\(index+1).circle.fill"
                      :"\(index+1).circle")
                    .foregroundStyle(snack == selection ? .ultraThickMaterial : .thinMaterial)
                    .frame(width: 100, height: 30)
            }
        }
        .animation(.easeOut(duration: 0.25), value: selection)
        .onTapGesture {
            guard snack.quantity > 0 else { return }
            selection = snack
        }
    }
}


struct SnackView_Previews: PreviewProvider {
    @State static var selection : Snack?
    
    static var previews: some View {
        CustomerSnackView(selection: SnackView_Previews.$selection)
    }
}
