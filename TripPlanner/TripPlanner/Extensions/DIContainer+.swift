import Core
import Repository

extension DIContainer {
    var tripRepository: TripRepositoryProtocol? {
        services[RepositoryService.self]?.tripRepository
    }
}
