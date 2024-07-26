import Foundation

extension Result : Identifiable where Success : Identifiable {
    
    public var id : String {
        switch self {
        case .success(let result):
            return String(ID(describing: result.id))
        case.failure(let error):
            return String(ID(describing: error))
        }
    }
}
