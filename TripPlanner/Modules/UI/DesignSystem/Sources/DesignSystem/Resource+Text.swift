import Foundation

extension Resource {
    public enum Text: String, LocalizedEnum {
        public static var prefix: String = "tui.pripplanner."

        case greeting
    }
}

// MARK: - Text.Error
extension Resource.Text {
    public enum Error: String, LocalizedEnum {
        public static var prefix: String = Resource.Text.prefix + "error."

        case general
        case noData
        case noConnection
        case noConnectionCheck
        case actionRetry
    }
}

// MARK: - Text.TripList
extension Resource.Text {
    public enum TripList: String, LocalizedEnum {
        public static var prefix: String = Resource.Text.prefix + "triplist."

        case connection
        case from
        case to
        case selectCity
        case foundTrips
        case suggestions
        case price
        case noTripsBetweenCities
        case sameCities
        case stop
        case stops
        case direct
    }
}

// MARK: - Text.TripList
extension Resource.Text {
    public enum Citypicker: String, LocalizedEnum {
        public static var prefix: String = Resource.Text.prefix + "citypicker."

        case close
        case noCityAvailable
        case searchTheCity
        case selectDeparture
        case selectArrival
    }
}
