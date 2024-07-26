import Foundation

class Coin : Currency {    
    
    private(set) var value : Decimal
    private(set) var text : String
    private(set) var quantity : Int
    
    static var twoPound = Coin(value: 2.00, text: "£2", quantity: 2)
    static var onePound = Coin(value: 1.00, text: "£1", quantity: 3)
    static var fiftyPence = Coin(value: 0.50, text: "50p", quantity: 4)
    static var twentyPence = Coin(value: 0.20, text: "20p", quantity: 5)
    static var tenPence = Coin(value: 0.10, text: "10p", quantity: 10)
    static var fivePence = Coin(value: 0.05, text: "5p", quantity: 20)
        
    var totalValue : Decimal { value * Decimal(quantity) }
    
    private init(value: Decimal, text: String, quantity: Int) {
        self.value = value
        self.text = text
        self.quantity = quantity
    }
    
    func increaseQuantity(by quantity: Int) {
        self.quantity += quantity
    }
    
    func reduceQuantity(by quantity : Int) {
        self.quantity -= quantity
    }
}
