import Foundation

class Vertex<Element: Equatable> {
    let value: Element
    private(set) var adjacentEdges: [DirectedEdge<Element>] = []

    var index: Int = 0

    init(_ value: Element) {
        self.value = value
    }

    func reset() {
        self.index = 0
        self.adjacentEdges = []
    }

    func addEdge(_ edge: DirectedEdge<Element>) {
        self.adjacentEdges.append(edge)
    }

    func edgeForDestination(
        _ destination: Vertex<Element>
    ) -> DirectedEdge<Element>? {
        return adjacentEdges.filter { $0.destination == destination }.first
    }
}

extension Vertex: Equatable {
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.value == rhs.value && lhs.adjacentEdges == rhs.adjacentEdges
    }
}

extension Vertex: CustomStringConvertible {
    var description: String {
        return "[\(value)]"
    }
}
