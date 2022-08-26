import Combine
import Foundation
import Repository

// MARK: - TripListViewModelProtocol
protocol TripListViewModelProtocol: ObservableObject {}

// MARK: - TripListViewModel
final class TripListViewModel: TripListViewModelProtocol & TripListFlowStateProtocol {

    private let repository: TripRepositoryProtocol
    private var loadingCancellables: Set<AnyCancellable> = .init()

    init(repository: TripRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Flow state
    @Published var route: TripListRoute?
}

#if DEBUG
    extension TripListViewModel {
        static var preview: Self {
            .init(repository: .mock)
        }
    }
#endif
