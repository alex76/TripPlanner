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

    func testAdjacentEdges() {
        let v1 = Vertex<Int>(1)
        let v3 = Vertex<Int>(3)
        let v5 = Vertex<Int>(5)
        let v7 = Vertex<Int>(7)
        let v8 = Vertex<Int>(8)
        let v9 = Vertex<Int>(9)
        let v10 = Vertex<Int>(10)

        let grapgh = constructGraph(with: [v1, v3, v5, v7, v8, v9, v10])

        grapgh.addEdge(source: v7, destination: v3)
        grapgh.addEdge(source: v7, destination: v5)
        grapgh.addEdge(source: v7, destination: v10)
        grapgh.addEdge(source: v3, destination: v8)
        grapgh.addEdge(source: v3, destination: v9)

        XCTAssertEqual(
            grapgh.adjacentEdges(forVertex: v7).map(\.destination.value),
            [3, 5, 10]
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

        let grapgh = constructGraph(with: [
            london, tokyo, porto, sydney, capeTown, newYork, losAngeles,
        ])

        grapgh.addEdge(source: london, destination: tokyo, weight: 220)
        grapgh.addEdge(source: tokyo, destination: london, weight: 200)
        grapgh.addEdge(source: london, destination: porto, weight: 50)
        grapgh.addEdge(source: tokyo, destination: sydney, weight: 100)
        grapgh.addEdge(source: sydney, destination: capeTown, weight: 200)
        grapgh.addEdge(source: capeTown, destination: london, weight: 800)
        grapgh.addEdge(source: london, destination: newYork, weight: 400)
        grapgh.addEdge(source: newYork, destination: losAngeles, weight: 120)
        grapgh.addEdge(source: losAngeles, destination: tokyo, weight: 150)

        grapgh.edges().forEach { print($0) }

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

        let fromTokyoToSydney = grapgh.edges().first(where: {
            $0.source.value == "Tokyo" && $0.destination.value == "Sydney"
        })

        XCTAssertEqual(fromTokyoToSydney?.weight, 100)
        XCTAssertNil(
            grapgh.edges().first(where: {
                $0.source.value == "Sydney" && $0.destination.value == "Tokyo"
            })
        )
    }
}
