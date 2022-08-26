import Combine
import Core
import Foundation
import Repository
import SwiftUI

// MARK: - TripListViewModelProtocol
protocol TripListViewModelProtocol: ObservableObject {
    var connectionRequest: RequestState<Void> { get }

    var sourceCity: City? { get set }
    var destinationCity: City? { get set }

    var trips: [Trip] { get }

    func reloadConnections()
}

// MARK: - TripListViewModel
final class TripListViewModel: BaseViewModel, TripListViewModelProtocol, TripListFlowStateProtocol {

    private let repository: TripRepositoryProtocol
    private var loadingCancellables: Set<AnyCancellable> = .init()

    init(repository: TripRepositoryProtocol) {
        self.repository = repository
    }

    private func updateTrips() {
        guard let source = sourceCity,
            let destination = destinationCity
        else { return }

        loadingCancellables.cancelAll()
        trips = []
        repository.findTrips(from: source, to: destination)
            .sinkToResult { [weak self] in
                guard case .success(let data) = $0 else { return }
                self?.trips = data
            }
            .store(in: &loadingCancellables)
    }

    // MARK: - Flow state
    @Published var route: TripListRoute?

    func openCityPicker(for city: Binding<City?>) {
        self.route = .cityPicker(city)
    }

    // MARK: - ViewModelProtocol
    @Published private(set) var connectionRequest: RequestState<Void> = .notAsked
    @Published private(set) var trips: [Trip] = []
    @Published var sourceCity: City? {
        didSet { updateTrips() }
    }
    @Published var destinationCity: City? {
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
