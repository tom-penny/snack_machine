import Foundation
import Resolver

extension Resolver : ResolverRegistering {
        
    static public func registerAllServices() {
        register { ChangeRepository<Coin>([.twoPound, .onePound, .fiftyPence, .twentyPence, .tenPence, .fivePence]) }.scope(.application)
        
        register { RecursiveChangeCalculator<CurrencyType>(resolve()) as ChangeCalculatorStrategy }
        
        register { FirestoreSnackRepository() as SnackRepository }
        register { FirestoreTransactionRepository() as TransactionRepository }
        
        register { AuthViewModel() }
        
        register { AdminChangeViewModel<CurrencyType>(repository: resolve()) }
        register { AdminSnackViewModel(repository: resolve()) }
        
        register { CustomerViewModel<CurrencyType>(snackRepository: resolve(), transactionRepository: resolve(), changeRepository: resolve(), changeCalculator: resolve()) }
        
        register { CustomerChangeViewModel<CurrencyType>(repository: resolve()) }
        register { CustomerSnackViewModel(repository: resolve()) }
        
    }
}
