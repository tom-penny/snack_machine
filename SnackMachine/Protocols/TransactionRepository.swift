import Foundation

protocol TransactionRepository {
    func addTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> ())
}
