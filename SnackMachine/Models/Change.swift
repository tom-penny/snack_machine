import Foundation

class Change<Unit : Currency> : Sequence {

    fileprivate var units : [Unit : Int]

    var isEmpty: Bool { units.isEmpty }

    var totalValue: Decimal {
        units.keys.reduce(0, { $0 + ($1.value * Decimal(units[$1] ?? 0))})
    }

    init(units: [Unit : Int]) {
        self.units = units
    }

    func makeIterator() -> DictionaryIterator<Unit, Int> {
        return units.makeIterator()
    }
}

class Escrow<Unit : Currency> : Change<Unit> {

    init() {
        super.init(units: [:])
    }

    func addUnit(_ unit: Unit) {
        units[unit, default: 0] += 1
    }
}
