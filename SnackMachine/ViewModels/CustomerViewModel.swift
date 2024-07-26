import Foundation
import Resolver

class CustomerViewModel<Unit : Currency> : ViewModel {
    
    private var snackRepository : SnackRepository
    private var transactionRepository : TransactionRepository
    private var changeRepository : ChangeRepository<Unit>
    private var changeCalculator : ChangeCalculatorStrategy
    private var escrow = Escrow<Unit>()
    
    init(snackRepository: SnackRepository, transactionRepository: TransactionRepository, changeRepository: ChangeRepository<Unit>, changeCalculator: ChangeCalculatorStrategy) {
        self.snackRepository = snackRepository
        self.transactionRepository = transactionRepository
        self.changeRepository = changeRepository
        self.changeCalculator = changeCalculator
    }
        
    @Published var result: Result<Transaction, Error>? {
        willSet(newResult) {
            guard let newResult else { return }
            if case .success(let transaction) = newResult {
                transactionRepository.addTransaction(transaction) { result in
                    if case .failure(let error) = result {
                        print(error)
                    }
                }
            }
        }
    }

    @Published var remaining : Decimal = 0.00 {
        didSet {
            if remaining <= 0.00 {
                processTransaction()
            }
        }
    }
    
    @Published var selection : Snack? {
        didSet {
            guard let selection = selection else { return }
            if !escrow.isEmpty {
                let value = escrow.totalValue
                self.remaining = (selection.price) - value
            }
            else {
                self.remaining = selection.price
            }
        }
    }
    
    func insertUnit(_ unit: Unit) {
        guard selection != nil else { return }
        self.escrow.addUnit(unit)
        self.remaining -= unit.value
    }
    
    private func processTransaction() {
        guard var selection, remaining <= 0 else { return }
        
        // If selection out of stock
        guard selection.quantity > 0 else {
            dispense(escrow)
            publishResult {
                .failure(LocalError.outOfStock)
            }
            return
        }
        
        // If insufficient change available
        guard let units = remaining == 0 ? [:] : calculateChange(of: abs(remaining)) else {
            dispense(escrow)
            self.publishResult {
                .failure(LocalError.insufficientChange)
            }
            return
        }
        
        selection.reduceQuantity()
        snackRepository.updateSnack(selection) { result in
            // Database callback result
            switch result {
            case .success():
                let change = Change(units: units)
                if !change.isEmpty {
                    self.dispense(change)
                }
                self.publishResult {
                    .success(Transaction(snack: selection, change: change))
                }
            case .failure(_):
                self.dispense(self.escrow)
                self.publishResult {
                    .failure(LocalError.unableToDispense)
                }
            }
        }
    }
    
    private func publishResult(result: @escaping () -> Result<Transaction, Error>?) {
        self.selection = nil
        self.remaining = 0.00
        self.escrow = Escrow()
        self.result = result()
    }
    
    private func calculateChange(of amount: Decimal) -> [Unit : Int]? {
        changeCalculator.calculateChange(of: amount)
    }
    
    private func dispense(_ units: Change<Unit>) {
        for (unit, quantity) in units {
            unit.reduceQuantity(by: quantity)
            changeRepository.updateUnit(unit)
        }
    }
}

extension CustomerViewModel {
    
    enum LocalError : LocalizedError {
        
        case outOfStock
        case insufficientChange
        case unableToDispense
        
        var errorDescription: String? {
            switch self {
            case .outOfStock:
                return "Selection out of stock"
            case .insufficientChange:
                return "Insufficient change available"
            case .unableToDispense:
                return "Unable to dispense selection"
            }
        }
            
        var recoverySuggestion: String? {
            switch self {
            case .outOfStock:
                return "Returning your payment.\nPlease try a different selection."
            case .insufficientChange:
                return "Returning your payment.\nPlease try again later."
            case .unableToDispense:
                return "Returning your payment.\nPlease try a different selection."
            }
        }
    }
}
