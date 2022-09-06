import Core
import Foundation

#if DEBUG
    extension MockData {
        public enum Trip {}
    }

    extension MockData.Trip {
        public static var data: Trip {
            Trip(price: 1500, connections: (try? MockData.Connections.cities) ?? [])
        }
    }
#endif
