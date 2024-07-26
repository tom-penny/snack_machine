import Foundation

protocol Currency : Hashable, Equatable {
    
    var value : Decimal { get }
    var text : String { get }
    var quantity : Int { get }
    var totalValue : Decimal { get }
    
    func increaseQuantity(by quantity: Int)
    func reduceQuantity(by quantity : Int)
}

extension Currency {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
