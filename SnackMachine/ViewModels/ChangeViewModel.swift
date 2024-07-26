import SwiftUI
import Combine
import Resolver

class ChangeViewModel<Unit : Currency> : ViewModel {
    
    fileprivate var repository : ChangeRepository<Unit>
    private var cancellables = Set<AnyCancellable>()
    
    @Published var units : [Unit] = []
    
    init(repository: ChangeRepository<Unit>) {
        self.repository = repository
        repository.$collection.assign(to: \.units, on: self).store(in: &cancellables)
    }
}

class CustomerChangeViewModel<Unit : Currency> : ChangeViewModel<Unit> {
    
    func insertUnit(_ unit: Unit) {
        unit.increaseQuantity(by: 1)
        repository.updateUnit(unit)
    }
}

class AdminChangeViewModel<Unit : Currency> : ChangeViewModel<Unit> {
    
    var total : Decimal { units.reduce(0, { $0 + $1.totalValue} ) }

    func increaseQuantity(of unit: Unit, by quantity: Int) {
        unit.increaseQuantity(by: quantity)
        repository.updateUnit(unit)
    }
}
