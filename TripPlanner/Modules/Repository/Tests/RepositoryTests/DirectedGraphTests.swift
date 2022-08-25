import Utilities
import XCTest

@testable import Repository

final class DirectedGraphTests: XCTestCase {

    private func constructGraph<T: Equatable>(with vertices: [Vertex<T>]) -> DirectedGraph<T> {
        let graph = DirectedGraph<T>()
        for vertex in vertices {
            vertex.reset()
            graph.addVertex(vertex)
        }
        return graph
    }

    func testSelfLoop() {
        let v1 = Vertex<Int>(1)
        let graph = constructGraph(with: [v1])

        graph.addEdge(source: v1, destination: v1)
        XCTAssertTrue(graph.edges().isEmpty)
    }

    func testCounts() {
        let v1 = Vertex<Int>(1)
        let v2 = Vertex<Int>(2)
        let graph = constructGraph(with: [v1, v2])

        graph.addEdge(source: v1, destination: v1)
        graph.addEdge(source: v1, destination: v2)
        graph.addEdge(source: v2, destination: v1)
        graph.addEdge(source: v2, destination: v2)

        XCTAssertEqual(2, graph.edgesCount())
        XCTAssertEqual(2, graph.verticesCount())
    }

    func testAdjacentEdges() {
        let v1 = Vertex<Int>(1)
        let v3 = Vertex<Int>(3)
        let v5 = Vertex<Int>(5)
        let v7 = Vertex<Int>(7)
        let v8 = Vertex<Int>(8)
        let v9 = Vertex<Int>(9)
        let v10 = Vertex<Int>(10)

        let graph = constructGraph(with: [v1, v3, v5, v7, v8, v9, v10])

        graph.addEdge(source: v7, destination: v3)
        graph.addEdge(source: v7, destination: v5)
        graph.addEdge(source: v7, destination: v10)
        graph.addEdge(source: v3, destination: v8)
        graph.addEdge(source: v3, destination: v9)

        XCTAssertEqual(
            graph.adjacentEdges(forVertex: v7).map(\.destination.value),
            [3, 5, 10]
        )
    }

    func testDuplicateEdges() {
        let v1 = Vertex<Int>(1)
        let v2 = Vertex<Int>(2)
        let graph = constructGraph(with: [v1, v2])

        graph.addEdge(source: v1, destination: v1)
        graph.addEdge(source: v1, destination: v2)
        graph.addEdge(source: v1, destination: v2)
        graph.addEdge(source: v1, destination: v2)

        XCTAssertEqual(1, graph.edgesCount())
        XCTAssertEqual(2, graph.verticesCount())
    }

    func testLeafs() {
        let v1 = Vertex<String>("1")
        let v3 = Vertex<String>("3")
        let v5 = Vertex<String>("5")
        let v7 = Vertex<String>("7")
        let v8 = Vertex<String>("8")
        let v9 = Vertex<String>("9")
        let v10 = Vertex<String>("10")

        let graph = constructGraph(with: [v1, v3, v5, v7, v8, v9, v10])
        graph.addEdge(source: v7, destination: v3)
        graph.addEdge(source: v7, destination: v5)
        graph.addEdge(source: v7, destination: v10)
        graph.addEdge(source: v3, destination: v8)
        graph.addEdge(source: v3, destination: v9)
        graph.addEdge(source: v8, destination: v9)
        graph.addEdge(source: v9, destination: v7)

        XCTAssertEqual(
            Set(graph.leafs().map(\.value)),
            Set(["1", "5", "10"])
        )

        let connections = graph.findConnections(from: v3, to: v10)
            .sorted(by: { $0.routes.count < $1.routes.count })
        XCTAssertEqual(2, connections.count)
        XCTAssertEqual(0, connections[safe: 0]?.score)
        XCTAssertEqual(
            ["3", "9", "7", "10"],
            connections[safe: 0]?.routes.vertices.map(\.value)
        )
        XCTAssertEqual(
            ["3", "8", "9", "7", "10"],
            connections[safe: 1]?.routes.vertices.map(\.value)
        )
    }

    func testConnections() {
        let london: Vertex<String> = .init("London")
        let tokyo: Vertex<String> = .init("Tokyo")
        let porto: Vertex<String> = .init("Porto")
        let sydney: Vertex<String> = .init("Sydney")
        let capeTown: Vertex<String> = .init("Cape Town")
        let newYork: Vertex<String> = .init("New York")
        let losAngeles: Vertex<String> = .init("Los Angeles")

        let graph = constructGraph(with: [
            london, tokyo, porto, sydney, capeTown, newYork, losAngeles,
        ])

        graph.addEdge(source: london, destination: tokyo, weight: 220)
        graph.addEdge(source: tokyo, destination: london, weight: 200)
        graph.addEdge(source: london, destination: porto, weight: 50)
        graph.addEdge(source: tokyo, destination: sydney, weight: 100)
        graph.addEdge(source: sydney, destination: capeTown, weight: 200)
        graph.addEdge(source: capeTown, destination: london, weight: 800)
        graph.addEdge(source: london, destination: newYork, weight: 400)
        graph.addEdge(source: newYork, destination: losAngeles, weight: 120)
        graph.addEdge(source: losAngeles, destination: tokyo, weight: 150)

        XCTAssertEqual(
            london.adjacentEdges.map(\.destination.value),
            [tokyo, porto, newYork].map(\.value)
        )
        XCTAssertEqual(
            porto.adjacentEdges.map(\.destination.value),
            []
        )
        XCTAssertEqual(
            sydney.adjacentEdges.map(\.destination.value),
            [capeTown.value]
        )

        let fromTokyoToSydney = graph.edges().first(where: {
            $0.source.value == "Tokyo" && $0.destination.value == "Sydney"
        })

        XCTAssertEqual(fromTokyoToSydney?.weight, 100)
        XCTAssertNil(
            graph.edges().first(where: {
                $0.source.value == "Sydney" && $0.destination.value == "Tokyo"
            })
        )

        // connection: london -> sydney
        let connections1 = graph.findConnections(from: london, to: sydney)
            .sorted(by: { $0.score < $1.score })
        XCTAssertEqual(2, connections1.count)
        XCTAssertEqual(320, connections1[safe: 0]?.score)
        XCTAssertEqual(
            ["London", "Tokyo", "Sydney"],
            connections1[safe: 0]?.routes.vertices.map(\.value)
        )
        XCTAssertEqual(770, connections1[safe: 1]?.score)
        XCTAssertEqual(
            ["London", "New York", "Los Angeles", "Tokyo", "Sydney"],
            connections1[safe: 1]?.routes.vertices.map(\.value)
        )

        // connection: cape town -> london
        let connections2 = graph.findConnections(from: capeTown, to: london)
            .sorted(by: { $0.score < $1.score })
        XCTAssertEqual(1, connections2.count)
        XCTAssertEqual(800, connections2[safe: 0]?.score)
        XCTAssertEqual(
            ["Cape Town", "London"],
            connections2[safe: 0]?.routes.vertices.map(\.value)
        )

        // connection: los angeles -> porto
        let connections3 = graph.findConnections(from: losAngeles, to: porto)
            .sorted(by: { $0.score < $1.score })
        XCTAssertEqual(2, connections3.count)
        XCTAssertEqual(400, connections3[safe: 0]?.score)
        XCTAssertEqual(
            ["Los Angeles", "Tokyo", "London", "Porto"],
            connections3[safe: 0]?.routes.vertices.map(\.value)
        )
        XCTAssertEqual(1300, connections3[safe: 1]?.score)
        XCTAssertEqual(
            ["Los Angeles", "Tokyo", "Sydney", "Cape Town", "London", "Porto"],
            connections3[safe: 1]?.routes.vertices.map(\.value)
        )

        // connection: porto -> sydney
        let connections4 = graph.findConnections(from: porto, to: sydney)
            .sorted(by: { $0.score < $1.score })
        XCTAssertEqual(0, connections4.count)

        // connection: london -> london
        let connections5 = graph.findConnections(from: london, to: london)
            .sorted(by: { $0.score < $1.score })
        XCTAssertEqual(0, connections5.count)

        // connection: cape town -> los angeles
        let connections6 = graph.findConnections(from: capeTown, to: losAngeles)
            .sorted(by: { $0.score < $1.score })
        XCTAssertEqual(1, connections6.count)
        XCTAssertEqual(1320, connections6[safe: 0]?.score)
        XCTAssertEqual(
            ["Cape Town", "London", "New York", "Los Angeles"],
            connections6[safe: 0]?.routes.vertices.map(\.value)
        )
    }

}

// MARK: Helpers
extension Array where Element == DirectedEdge<String> {
    fileprivate var vertices: [Vertex<String>] {
        guard let first = self.first?.source else { return [] }
        return self.reduce([first]) { $0 + [$1.destination] }
    }
}
