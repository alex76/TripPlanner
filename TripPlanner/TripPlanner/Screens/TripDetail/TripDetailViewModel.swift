import Combine
import Core
import Repository

// MARK: - TripDetailViewModelProtocol
protocol TripDetailViewModelProtocol: ObservableObject {
    var trip: Trip { get }
}

// MARK: - TripDetailViewModel
final class TripDetailViewModel: BaseViewModel & TripDetailViewModelProtocol
        & TripDetailFlowStateProtocol
{

    init(trip: Trip) {
        self.trip = trip
    }

    // MARK: - Flow state
    @Published var route: TripDetailRoute?

    func openMap(for connection: Connection) {

    }

    // MARK: - ViewModelProtocol
    @Published private(set) var trip: Trip

}

// MARK: - Preview
#if DEBUG
    extension TripDetailViewModel {
        static var preview: Self {
            .init(trip: MockData.Trip.data)
        }
    }
#endif
