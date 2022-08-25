import Foundation

class DirectedEdge<Element: Equatable> {
    var source: Vertex<Element>
    var destination: Vertex<Element>

    init(source: Vertex<Element>, destination: Vertex<Element>) {
        self.source = source
        self.destination = destination
    }
}

extension DirectedEdge: Equatable {
    static func == (lhs: DirectedEdge, rhs: DirectedEdge) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}

extension DirectedEdge: CustomStringConvertible {
    var description: String {
        return "[\(source)->\(destination)]"
    }
}
