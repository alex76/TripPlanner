import Combine
import Core
import Foundation
import Utilities

// MARK: - URL
extension URL {
    fileprivate static var connectionList: URL? {
        URL(
            string:
                "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json"
        )
    }
}

// MARK: - Error
enum TripRepositoryError: Error {
    case invalidUrl
    case noData
}

// MARK: - TripRepositoryProtocol
public protocol TripRepositoryProtocol {
    func refreshConnections() -> Single<Void, Error>
    func fetchCities() -> Single<[City], Error>
    func fetchCities(for searchTerm: String) -> Single<[City], Error>
    func findTrips(from source: City, to destination: City) -> Single<[Trip], Error>
}

// MARK: - TripRepository
final class TripRepository: TripRepositoryProtocol {

    private var connectionGraph: DirectedGraph<City>?

    init() {}
    init(graph: DirectedGraph<City>?) {
        self.connectionGraph = graph
    }

    func refreshConnections() -> Single<Void, Error> {
        guard let url = URL.connectionList else {
            return Fail(error: TripRepositoryError.invalidUrl).asSingle()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { [weak self] (wrapper: ConnectionWrapper) in
                self?.connectionGraph = .init(connections: wrapper.connections)

                let debugDescription =
                    self?.connectionGraph?.edges().reduce("") {
                        $0
                            + "\n[\($1.source.value.name) --> \($1.destination.value.name)] (\($1.weight ?? 0))"
                    } ?? ""
                print("[GRAPH 🛠] --->\(debugDescription)\n<-- [GRAPH]")
            })
            .map { _ in }
            .receive(on: DispatchQueue.main)
            .asSingle()
    }

    func fetchCities() -> Single<[City], Error> {
        guard let graph = connectionGraph else {
            return Fail(error: TripRepositoryError.noData).asSingle()
        }
        return Just(graph.vertices.map(\.value))
            .setFailureType(to: Swift.Error.self)
            .asSingle()
    }

    func fetchCities(for searchTerm: String) -> Single<[City], Error> {
        guard let graph = connectionGraph else {
            return Fail(error: TripRepositoryError.noData).asSingle()
        }
        return Just(
            graph.vertices
                .map(\.value)
                .filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        )
        .setFailureType(to: Swift.Error.self)
        .asSingle()
    }

    func findTrips(from source: City, to destination: City) -> Single<[Trip], Error> {
        guard let graph = connectionGraph,
            let sourceVertex = graph.vertices.first(where: { $0.value == source }),
            let destinationVertex = graph.vertices.first(where: { $0.value == destination })
        else {
            return Fail(error: TripRepositoryError.noData).asSingle()
        }
        let trip = graph.findConnections(from: sourceVertex, to: destinationVertex)
            .map { graphResult -> Trip in
                return .init(
                    price: graphResult.score,
                    connections: graphResult.routes.map {
                        .init(
                            source: $0.source.value,
                            destination: $0.destination.value,
                            price: $0.weight ?? 0
                        )
                    }
                )
            }
            .sorted(by: { $0.price < $1.price })
        return Just(trip)
            .setFailureType(to: Swift.Error.self)
            .asSingle()
    }

}

#if DEBUG
    // MARK: - Mock
    extension TripRepositoryProtocol where Self == MockTripRepository {
        public static var mock: TripRepositoryProtocol { MockTripRepository() }
    }

    public final class MockTripRepository: TripRepositoryProtocol {
        private(set) var connectionGraph: DirectedGraph<City>?

        public func refreshConnections() -> Single<Void, Error> {
            do {
                return Just(try MockData.Connections.cities)
                    .setFailureType(to: Swift.Error.self)
                    .handleEvents(receiveOutput: { [weak self] (connections: [Connection]) in
                        self?.connectionGraph = .init(connections: connections)
                    })
                    .map { _ in }
                    .asSingle()
            } catch {
                return Fail(error: error).asSingle()
            }
        }
        public func fetchCities() -> Single<[City], Error> {
            Empty().asSingle()
        }
        public func fetchCities(for searchTerm: String) -> Single<[City], Error> {
            Empty().asSingle()
        }
        public func findTrips(from source: City, to destination: City) -> Single<[Trip], Error> {
            Empty().asSingle()
        }
    }
#endif
