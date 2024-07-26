import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Transaction : Identifiable, Codable {
    
    @DocumentID var id : String?
    @ServerTimestamp var createdTime : Timestamp?
    
    var snack : Snack
    var total : Decimal
    var change : Decimal
    var cash : Decimal
    var tally : [String : Int]
    
    init(snack: Snack, change: Change<some Currency>) {
        self.snack = snack
        self.total = snack.price
        self.change = change.totalValue
        self.cash = total + change.totalValue
        self.tally = change.reduce(into: [String : Int]()) { tally, change in
            tally[change.key.text] = change.value
        }
    }
}
