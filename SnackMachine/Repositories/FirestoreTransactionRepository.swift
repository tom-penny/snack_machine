import Foundation
import FirebaseFirestore

class FirestoreTransactionRepository : TransactionRepository {
    
    private var db = Firestore.firestore()
    
    func addTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> ()) {
        do {
            try db.collection("transactions").addDocument(from: transaction) { error in
                if let error {
                    completion(.failure(error))
                }
                else {
                    completion(.success(()))
                }
            }
        }
        catch {
            completion(.failure(error))
        }
    }
}
