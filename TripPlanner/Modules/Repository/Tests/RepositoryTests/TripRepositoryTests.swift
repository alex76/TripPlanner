import Combine
import Core
import Utilities
import XCTest

@testable import Repository

final class TripRepositoryTests: XCTestCase {

    func testGraphConstruction() throws {
        let expectation = XCTestExpectation()

        let repository = MockTripRepository()
        let task = repository.refreshConnections()
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { _ in }
            )

        wait(for: [expectation], timeout: 1)
        task.cancel()

        XCTAssertNotNil(repository.connectionGraph)
        XCTAssertEqual(7, repository.connectionGraph?.verticesCount())
        XCTAssertEqual(9, repository.connectionGraph?.edgesCount())
    }

    func testCities() throws {
        let dataExpectation = XCTestExpectation()

        let mockRepository = MockTripRepository()
        let task = mockRepository.refreshConnections()
            .sink(
                receiveCompletion: { _ in dataExpectation.fulfill() },
                receiveValue: { _ in }
            )

        wait(for: [dataExpectation], timeout: 1)
        task.cancel()

        let realRepository = TripRepository(graph: mockRepository.connectionGraph)

        let citiesExpectation = XCTestExpectation()
        var cities: [City] = []
        let citiesTask = realRepository.fetchCities()
            .sink(
                receiveCompletion: { _ in citiesExpectation.fulfill() },
                receiveValue: { cities = $0 }
            )

        wait(for: [citiesExpectation], timeout: 1)
        citiesTask.cancel()

        XCTAssertEqual(
            Set(["London", "Tokyo", "Sydney", "Cape Town", "Porto", "New York", "Los Angeles"]),
            Set(cities.map(\.name))
        )

        let searchExpectation = XCTestExpectation()
        let searchTask = realRepository.fetchCities(for: "yo")
            .sink(
                receiveCompletion: { _ in searchExpectation.fulfill() },
                receiveValue: { cities = $0 }
            )

        wait(for: [searchExpectation], timeout: 1)
        searchTask.cancel()

        XCTAssertEqual(
            Set(["Tokyo", "New York"]),
            Set(cities.map(\.name))
        )
    }

    func testTrips() throws {
        let dataExpectation = XCTestExpectation()

        let mockRepository = MockTripRepository()
        let task = mockRepository.refreshConnections()
            .sink(
                receiveCompletion: { _ in dataExpectation.fulfill() },
                receiveValue: { _ in }
            )

        wait(for: [dataExpectation], timeout: 1)
        task.cancel()

        let realRepository = TripRepository(graph: mockRepository.connectionGraph)

        let tripExpectation = XCTestExpectation()
        var trips: [Trip] = []

        let tripTask = realRepository.findTrips(
            from: mockRepository.connectionGraph!.vertices
                .map(\.value)
                .first(where: { $0.name == "Los Angeles" })!,
            to: mockRepository.connectionGraph!.vertices
                .map(\.value)
                .first(where: { $0.name == "Porto" })!
        )
        .sink(
            receiveCompletion: { _ in tripExpectation.fulfill() },
            receiveValue: { trips = $0 }
        )

        wait(for: [tripExpectation], timeout: 1)
        tripTask.cancel()

        XCTAssertEqual(2, trips.count)
        XCTAssertEqual(400, trips[safe: 0]?.price)
        XCTAssertEqual(
            ["Los Angeles", "Tokyo", "London", "Porto"],
            trips[safe: 0]?.connections.stops.map(\.name)
        )
        XCTAssertEqual(1300, trips[safe: 1]?.price)
        XCTAssertEqual(
            ["Los Angeles", "Tokyo", "Sydney", "Cape Town", "London", "Porto"],
            trips[safe: 1]?.connections.stops.map(\.name)
        )
    }

}

// MARK: Helpers
extension Array where Element == Connection {
    fileprivate var stops: [City] {
        guard let first = self.first?.source else { return [] }
        return self.reduce([first]) { $0 + [$1.destination] }
    }
}
