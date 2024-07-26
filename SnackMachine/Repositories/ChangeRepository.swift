import Foundation

class ChangeRepository<Unit : Currency> : ObservableRepository<Unit> {

    init(_ units: [Unit]) {
        super.init()
        self.collection = units
    }

    func updateUnit(_ unit: Unit) {
        if let index = self.collection.firstIndex(where: { $0 == unit }) {
            collection[index] = unit
        }
    }
}
