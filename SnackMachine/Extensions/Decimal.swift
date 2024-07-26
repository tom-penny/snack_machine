import Foundation

extension Decimal {
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber)!
    }
    
    func toCurrency(_ currencyCode : String) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: self as NSNumber)!
    }
}
