import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class FirestoreSnackRepository : ObservableRepository<Snack>, SnackRepository {
    
    private var db = Firestore.firestore()
    
    override init() {
        super.init()
        loadSnacks()
    }
    
    func addSnack(_ snack : Snack) {
        do {
            try db.collection("snacks").addDocument(from: snack)
        }
        catch {
            
        }
    }
    
    func updateSnack(_ snack: Snack, completion: @escaping (Result<Void, Error>) -> ()) {
        guard let id = snack.id else { return }
        do {
            try db.collection("snacks").document(id).setData(from: snack) { error in
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
    
    private func loadSnacks() {
        db.collection("snacks").addSnapshotListener { snapshot, error in
            if let snapshot {
                self.collection = snapshot.documents.compactMap { document in
                    try? document.data(as: Snack.self)
                }
            }
        }
    }
}
