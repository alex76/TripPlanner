import Core
import Foundation

// MARK: - RepositoryServiceProtocol
public protocol RepositoryServiceProtocol: ServiceProtocol {
    var tripRepository: TripRepositoryProtocol { get }
}

// MARK: - RepositoryService
public final class RepositoryService: RepositoryServiceProtocol {

    public let tripRepository: TripRepositoryProtocol

    public init() {
        self.tripRepository = TripRepository()
    }

}
