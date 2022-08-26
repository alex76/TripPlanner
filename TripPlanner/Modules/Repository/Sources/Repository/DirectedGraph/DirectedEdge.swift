import Foundation

class DirectedEdge<Element: Equatable> {
    let source: Vertex<Element>
    let destination: Vertex<Element>
    let weight: Double?

    init(
        source: Vertex<Element>,
        destination: Vertex<Element>,
        weight: Double? = nil
    ) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

extension DirectedEdge: Equatable {
    static func == (lhs: DirectedEdge, rhs: DirectedEdge) -> Bool {
        return lhs.source == rhs.source
            && lhs.destination == rhs.destination
            && lhs.weight == rhs.weight
    }
}

extension DirectedEdge: CustomStringConvertible {
    var description: String {
        return "[\(source)->\(destination)\(weight != nil ? " (\(weight!))" : "")]"
    }
}
