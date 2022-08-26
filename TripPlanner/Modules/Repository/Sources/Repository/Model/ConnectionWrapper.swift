import Foundation

/// Internal helper for parsing a connection list
struct ConnectionWrapper: Codable {
    let connections: [Connection]
}
