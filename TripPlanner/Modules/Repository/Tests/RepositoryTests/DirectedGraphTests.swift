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
}
