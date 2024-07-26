import SwiftUI
import Combine
import Resolver

class SnackViewModel : ViewModel {
    
    fileprivate var repository : SnackRepository
    private var cancellables = Set<AnyCancellable>()
    
    @Published var snacks : [Snack] = []
    
    init(repository: SnackRepository) {
        self.repository = repository
        repository.$collection.assign(to: \.snacks, on: self).store(in: &cancellables)
    }
}

class CustomerSnackViewModel : SnackViewModel {}

class AdminSnackViewModel : SnackViewModel {
    
    func updatePrice(of snack: Snack, to price: Decimal) {
        var updatedSnack = snack
        updatedSnack.changePrice(to: price)
        repository.updateSnack(updatedSnack) { result in
            if case .failure(let error) = result {
                print(error)
            }
        }
    }
}
