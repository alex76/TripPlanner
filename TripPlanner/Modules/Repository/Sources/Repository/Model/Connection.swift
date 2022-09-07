import Foundation

public struct Connection: Encodable, Hashable {
    public let source: City
    public let destination: City
    public let price: Double
}

// MARK: -  Decoding
extension Connection: Decodable {
    enum RootKeys: String, CodingKey {
        case from, to, coordinates, price
    }

    enum CoordinatesKeys: String, CodingKey {
        case from, to
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let sourceName = try container.decode(String.self, forKey: .from)
        let destinationName = try container.decode(String.self, forKey: .to)

        let coordinatesContainer = try container.nestedContainer(
            keyedBy: CoordinatesKeys.self,
            forKey: .coordinates
        )
        let sourceCoordinate = try coordinatesContainer.decode(City.Coordinate.self, forKey: .from)
        let destinationCoordinate = try coordinatesContainer.decode(
            City.Coordinate.self,
            forKey: .to
        )

        self.price = try container.decode(Double.self, forKey: .price)
        self.source = .init(name: sourceName, coordinate: sourceCoordinate)
        self.destination = .init(name: destinationName, coordinate: destinationCoordinate)
    }
}

extension Array where Element == Connection {
    public var cities: [City] {
        guard let first = self.first?.source else { return [] }
        return self.reduce([first]) { $0 + [$1.destination] }
    }
}
