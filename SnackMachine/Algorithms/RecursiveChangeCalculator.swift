import Foundation

class RecursiveChangeCalculator<Unit : Currency> : ChangeCalculatorStrategy {
    
    typealias Handler = ChangeHandler<Unit>
        
    private var firstHandler : Handler?
    
    init(_ repository: ChangeRepository<Unit>) {
        self.firstHandler = createHandler(repository.collection)
    }
    
    func calculateChange<Unit : Currency>(of amount: Decimal) -> [Unit : Int]? {
        guard let firstHandler = firstHandler as? ChangeHandler<Unit> else { return nil }
        return firstHandler.processChange(amount, change: [:])
    }
    
    // Recursive initialiser for linked-list of handlers

    private func createHandler(_ units: [Unit]) -> Handler? {
        guard let first = units.first else {
            return nil
        }
        
        let remaining = Array(units.dropFirst())
        let next = createHandler(remaining)
        
        return Handler(first, next: next)
    }
}

extension RecursiveChangeCalculator {
    
    class ChangeHandler<Unit : Currency> {
        
        private let unit : Unit
        private var next: ChangeHandler?
        
        init(_ unit: Unit, next: ChangeHandler<Unit>?) {
            self.unit = unit
            self.next = next
        }
            
        func processChange(_ amount: Decimal, change: [Unit : Int]) -> [Unit : Int]? {
            guard amount >= unit.value, unit.quantity > 0 else {
                return next?.processChange(amount, change: change)
            }
            
            var count = 0
            var change = change
            var amount = amount
            
            while amount >= unit.value && count < unit.quantity {
                change[unit, default: 0] += 1
                amount -= unit.value
                count += 1
            }

            if amount == 0 {
                return change
            }
            
            return next?.processChange(amount, change: change)
        }
    }
}
