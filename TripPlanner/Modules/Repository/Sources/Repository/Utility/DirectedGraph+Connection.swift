import Foundation
import SwiftUI

extension DirectedGraph where Element == City {

    convenience init(connections: [Connection]) {
        self.init()

        for connection in connections {
            let sourceVertex = self.addVertex(Vertex<City>(connection.source))
            let destinationVertex = self.addVertex(Vertex<City>(connection.destination))

            self.addEdge(
                source: sourceVertex,
                destination: destinationVertex,
                weight: connection.price
            )
        }
    }

}
