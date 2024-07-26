import Foundation
import FirebaseFirestoreSwift

struct Snack : Identifiable, Codable, Hashable {
    
    @DocumentID var id : String?
    
    var name : String
    var quantity : Int
    var price : Decimal
    var img : String
    
    mutating func changePrice(to price: Decimal) {
        self.price = price
    }
    
    mutating func reduceQuantity() {
        self.quantity -= 1
    }
}
