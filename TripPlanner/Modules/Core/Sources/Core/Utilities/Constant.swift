import Foundation

public enum Constant {}

// MARK: - Formatters
extension Constant {
    public enum Formatter {
        public static let price: NumberFormatter = {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale.current
            return currencyFormatter
        }()
    }
}
