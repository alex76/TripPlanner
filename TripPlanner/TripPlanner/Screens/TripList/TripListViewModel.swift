import Combine
import Core
import Foundation
import Repository

// MARK: - TripListViewModelProtocol
protocol TripListViewModelProtocol: ObservableObject {
    var connectionRequest: RequestState<Void> { get }

    func reloadConnections()
}

// MARK: - TripListViewModel
final class TripListViewModel: BaseViewModel, TripListViewModelProtocol, TripListFlowStateProtocol {

    private let repository: TripRepositoryProtocol
    private var loadingCancellables: Set<AnyCancellable> = .init()

    init(repository: TripRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Flow state
    @Published var route: TripListRoute?

    // MARK: - ViewModelProtocol
    @Published private(set) var connectionRequest: RequestState<Void> = .notAsked

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
