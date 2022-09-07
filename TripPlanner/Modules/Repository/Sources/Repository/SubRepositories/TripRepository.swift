import Combine
import Core
import DesignSystem
import Foundation
import SwiftUI
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
    func fetchSuggestions() -> Single<[Trip], Error>
    func findTrips(from departure: City, to arrival: City) -> Single<[Trip], Error>
}

// MARK: - TripRepository
final class TripRepository: TripRepositoryProtocol {

    private var connectionGraph: DirectedGraph<City>?

    let processingQueue: DispatchQueue = .init(
        label: "queue.repository.trip.processing"
    )

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

    func fetchSuggestions() -> Single<[Trip], Error> {
        guard let graph = connectionGraph else {
            return Fail(error: TripRepositoryError.noData).asSingle()
        }
        return Deferred {
            Future { promise in
                let trips = graph.edges()
                    .map { edge -> Trip in
                        .init(
                            price: edge.weight ?? 0,
                            connections: [
                                .init(
                                    source: edge.source.value,
                                    destination: edge.destination.value,
                                    price: edge.weight ?? 0
                                )
                            ]
                        )
                    }
                    .sorted(by: { $0.price < $1.price })
                    .prefix(3)
                promise(.success(Array(trips)))
            }
        }
        .subscribe(on: processingQueue)
        .delay(for: .milliseconds(600), scheduler: DispatchQueue.main)
        .asSingle()
    }

    func findTrips(from departure: City, to arrival: City) -> Single<[Trip], Error> {
        guard let graph = connectionGraph,
            let sourceVertex = graph.vertices.first(where: { $0.value == departure }),
            let destinationVertex = graph.vertices.first(where: { $0.value == arrival })
        else {
            return Fail(error: TripRepositoryError.noData).asSingle()
        }

        return Deferred {
            Future { promise in
                let trips = graph.findConnections(from: sourceVertex, to: destinationVertex)
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
                promise(.success(trips))
            }
        }
        .subscribe(on: processingQueue)
        .delay(for: .milliseconds(600), scheduler: DispatchQueue.main)
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
        public func fetchSuggestions() -> Single<[Trip], Error> {
            guard let graph = connectionGraph else {
                return Fail(error: TripRepositoryError.noData).asSingle()
            }
            let trips = graph.edges()
                .map { edge -> Trip in
                    .init(
                        price: edge.weight ?? 0,
                        connections: [
                            .init(
                                source: edge.source.value,
                                destination: edge.destination.value,
                                price: edge.weight ?? 0
                            )
                        ]
                    )
                }
                .sorted(by: { $0.price < $1.price })
                .prefix(3)
            return Just(Array(trips))
                .setFailureType(to: Swift.Error.self)
                .asSingle()
        }
        public func findTrips(from source: City, to destination: City) -> Single<[Trip], Error> {
            Empty().asSingle()
        }
    }
#endif
