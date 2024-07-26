import Foundation

protocol ChangeCalculatorStrategy {
    func calculateChange<Unit : Currency>(of amount: Decimal) -> [Unit : Int]?
}
