import Foundation

struct LocalErrorWrapper : LocalizedError {
    
    private let error : LocalizedError

    var errorDescription: String? {
        error.errorDescription
    }

    var recoverySuggestion: String? {
        error.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localError = error as? LocalizedError else { return nil }
        self.error = localError
    }
}
