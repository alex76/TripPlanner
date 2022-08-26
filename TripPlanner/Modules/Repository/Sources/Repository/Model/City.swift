import Foundation

public struct City: Codable, Hashable {
    public let name: String
    public let coordinate: Coordinate
}

extension City {
    public struct Coordinate: Codable, Hashable {
        public let lat: Double
        public let long: Double
    }
}
