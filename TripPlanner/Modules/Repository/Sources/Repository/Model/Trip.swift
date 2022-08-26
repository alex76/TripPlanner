import Foundation

public struct Trip: Codable, Hashable {
    public let price: Double
    public let connections: [Connection]
}
