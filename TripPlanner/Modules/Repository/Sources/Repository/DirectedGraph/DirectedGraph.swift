import Foundation

class DirectedGraph<Element: Equatable> {
    private(set) var vertices: [Vertex<Element>] = []

    init() {}

    @discardableResult
    func addVertex(_ vertex: Vertex<Element>) -> Vertex<Element> {
        if let foundVertex = vertices.first(where: { $0.value == vertex.value }) {
            return foundVertex
        }
        vertex.index = vertices.count
        vertices.append(vertex)
        return vertex
    }

    func addEdge(
        source: Vertex<Element>,
        destination: Vertex<Element>,
        weight: Double? = nil
    ) {
        guard source != destination && source.edgeForDestination(destination) == nil else {
            return
        }
        let newEdge = DirectedEdge<Element>(
            source: source,
            destination: destination,
            weight: weight
        )
        source.addEdge(newEdge)
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

    func leafs() -> [Vertex<Element>] {
        vertices.filter { $0.adjacentEdges.isEmpty }
    }
}

// MARK: - Find connections
extension DirectedGraph {

    typealias SearchResult = [(score: Double, routes: [DirectedEdge<Element>])]

    func findConnections(
        from source: Vertex<Element>,
        to destination: Vertex<Element>
    ) -> SearchResult {
        guard
            vertices.contains(source)
                && vertices.contains(destination)
                && source != destination
        else { return [] }
        var connections: SearchResult = []
        findConnections(
            from: source,
            to: destination,
            score: 0,
            visited: [],
            connections: &connections
        )
        return connections
    }

    private func findConnections(
        from source: Vertex<Element>,
        to finalDestination: Vertex<Element>,
        score: Double,
        visited: [DirectedEdge<Element>],
        connections: inout SearchResult
    ) {
        for edge in source.adjacentEdges {
            let newVisited = visited + [edge]
            let newScore = score + (edge.weight ?? 0)

            let visitedVertices = newVisited.map(\.source.index)
            let nextStop = edge.destination

            if nextStop.index == finalDestination.index {
                connections.append((score: newScore, routes: newVisited))
                continue
            }
            if visitedVertices.contains(nextStop.index) {
                continue
            }
            findConnections(
                from: nextStop,
                to: finalDestination,
                score: newScore,
                visited: newVisited,
                connections: &connections
            )
        }
    }

}
