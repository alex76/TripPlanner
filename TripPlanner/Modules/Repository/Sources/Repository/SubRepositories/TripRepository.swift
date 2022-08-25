import Foundation

// MARK: - TripRepositoryProtocol
public protocol TripRepositoryProtocol {

}

// MARK: - TripRepository
final class TripRepository: TripRepositoryProtocol {

}

#if DEBUG
    // MARK: - Mock
    extension TripRepositoryProtocol where Self == MockTripRepository {
        public static var mock: TripRepositoryProtocol { MockTripRepository() }
    }

    public final class MockTripRepository: TripRepositoryProtocol {

    }
#endif
