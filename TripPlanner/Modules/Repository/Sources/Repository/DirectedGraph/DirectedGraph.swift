import Foundation

class DirectedGraph<Element: Equatable> {
    private(set) var vertices: [Vertex<Element>] = []

    init() {}

    func addVertex(_ vertex: Vertex<Element>) {
        vertex.index = vertices.count
        vertices.append(vertex)
    }

    func addEdge(source: Vertex<Element>, destination: Vertex<Element>) {
        if source != destination && source.edgeForDestination(destination) == nil {
            let newEdge = DirectedEdge<Element>(
                source: source,
                destination: destination
            )
            source.addEdge(newEdge)
        }
    }

    func adjacentEdges(forVertex vertex: Vertex<Element>) -> [DirectedEdge<Element>] {
        return vertex.adjacentEdges
    }

    func edges() -> [DirectedEdge<Element>] {
        return
            vertices
            .reduce([DirectedEdge<Element>]()) {
                (result, vertex) -> [DirectedEdge<Element>] in
                return result + vertex.adjacentEdges
            }
    }

    func edgesCount() -> Int {
        return edges().count
    }

    func verticesCount() -> Int {
        return vertices.count
    }
}
