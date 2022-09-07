import Core
import Foundation
import Repository

// MARK: - MapViewModelProtocol
protocol MapViewModelProtocol: ObservableObject {
    var connections: [Connection] { get }
}

// MARK: - MapViewModel
final class MapViewModel: BaseViewModel, MapViewModelProtocol {

    init(connections: [Connection]) {
        self.connections = connections
    }

    // MARK: - ViewModelProtocol
    @Published private(set) var connections: [Connection]

}

#if DEBUG
    extension MapViewModel {
        static var preview: Self {
            .init(connections: MockData.Trip.data.connections)
        }
    }
#endif
