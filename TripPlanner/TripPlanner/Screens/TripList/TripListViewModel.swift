import Combine
import Core
import Foundation
import Repository
import SwiftUI

// MARK: - TripListViewModelProtocol
protocol TripListViewModelProtocol: ObservableObject {
    var connectionRequest: RequestState<Void> { get }

    var departureCity: City? { get set }
    var arrivalCity: City? { get set }

    var trips: [Trip] { get }

    func reloadConnections()
    func swapDestinations()
}

// MARK: - TripListViewModel
final class TripListViewModel: BaseViewModel, TripListViewModelProtocol, TripListFlowStateProtocol {

    private let repository: TripRepositoryProtocol
    private var loadingCancellables: Set<AnyCancellable> = .init()

    init(repository: TripRepositoryProtocol) {
        self.repository = repository
    }

    private func updateTrips() {
        guard let departure = departureCity,
            let arrival = arrivalCity
        else { return }

        loadingCancellables.cancelAll()
        trips = []
        repository.findTrips(from: departure, to: arrival)
            .sinkToResult { [weak self] in
                guard case .success(let data) = $0 else { return }
                self?.trips = data
            }
            .store(in: &loadingCancellables)
    }

    // MARK: - Flow state
    @Published var route: TripListRoute?

    func openCityPicker(for city: Binding<City?>, type: DestinationType) {
        self.route = .cityPicker(city, type: type)
    }

    func openTrip(_ trip: Trip) {

    }

    // MARK: - ViewModelProtocol
    @Published private(set) var connectionRequest: RequestState<Void> = .notAsked
    @Published private(set) var trips: [Trip] = []
    @Published var departureCity: City? {
        didSet { updateTrips() }
    }
    @Published var arrivalCity: City? {
        didSet { updateTrips() }
    }

    func reloadConnections() {
        loadingCancellables.cancelAll()
        connectionRequest = .loading(last: nil)

        repository.refreshConnections()
            .sinkToResult { [weak self] result in
                switch result {
                case .success:
                    self?.connectionRequest = .success(())
                case .failure(let error):
                    self?.connectionRequest = .failure(error)
                }
            }
            .store(in: &loadingCancellables)
    }

    func swapDestinations() {
        guard departureCity != nil || arrivalCity != nil else { return }
        let departure = departureCity
        let arrival = arrivalCity

        departureCity = arrival
        arrivalCity = departure
    }
}

extension Array where Element == Connection {
    var stops: [City] {
        guard let first = self.first?.source else { return [] }
        return self.reduce([first]) { $0 + [$1.destination] }
    }
}

#if DEBUG
    extension TripListViewModel {
        static var preview: Self {
            .init(repository: .mock)
        }
    }
#endif
