import Combine
import Core
import Repository

// MARK: - TripStopListViewModelProtocol
protocol TripStopListViewModelProtocol: ObservableObject {
    var trip: Trip { get }
}

// MARK: - TripStopListViewModel
final class TripStopListViewModel: BaseViewModel & TripStopListViewModelProtocol
        & TripStopListFlowStateProtocol
{

    init(trip: Trip) {
        self.trip = trip
    }

    // MARK: - Flow state
    @Published var route: TripStopListRoute?

    func openMap(for connection: Connection) {

    }

    // MARK: - ViewModelProtocol
    @Published private(set) var trip: Trip

}

// MARK: - Preview
#if DEBUG
    extension TripStopListViewModel {
        static var preview: Self {
            .init(trip: MockData.Trip.data)
        }
    }
#endif
