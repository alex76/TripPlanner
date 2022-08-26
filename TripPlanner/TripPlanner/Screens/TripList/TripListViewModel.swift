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
        print("update trips")
    }

    // MARK: - Flow state
    @Published var route: TripListRoute?

    func openCityPicker(for city: Binding<City?>) {
        self.route = .cityPicker(city)
    }

    // MARK: - ViewModelProtocol
    @Published private(set) var connectionRequest: RequestState<Void> = .notAsked
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

#if DEBUG
    extension TripListViewModel {
        static var preview: Self {
            .init(repository: .mock)
        }
    }
#endif
