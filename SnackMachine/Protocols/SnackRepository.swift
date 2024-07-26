import Foundation
import SwiftUI

protocol SnackRepository : ObservableRepository<Snack> {
    func updateSnack(_ snack: Snack, completion: @escaping (Result<Void, Error>) -> Void)
}
