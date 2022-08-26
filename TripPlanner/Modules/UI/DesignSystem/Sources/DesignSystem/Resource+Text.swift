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

        case selectCity
    }
}

// MARK: - Text.TripList
extension Resource.Text {
    public enum Citypicker: String, LocalizedEnum {
        public static var prefix: String = Resource.Text.prefix + "citypicker."

        case noCityAvailable
        case lookForACity
        case cityPicker
    }
}
