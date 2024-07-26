import Foundation

class ObservableRepository<T> : ObservableObject {
    typealias Entity = T
    @Published var collection = [Entity]()
}
