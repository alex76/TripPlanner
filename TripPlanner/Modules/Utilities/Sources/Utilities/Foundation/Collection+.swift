import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Equatable {
    public subscript(safe bounds: Range<Int>) -> ArraySlice<Element>? {
        if bounds.lowerBound > count { return nil }
        let lower = Swift.max(0, bounds.lowerBound)
        let upper = Swift.max(0, Swift.min(count, bounds.upperBound))
        return self[lower..<upper]
    }

    public subscript(safe lower: Int?, _ upper: Int?) -> ArraySlice<Element>? {
        let lower = lower ?? 0
        let upper = upper ?? count
        if lower > upper { return nil }
        return self[safe: lower..<upper]
    }
}
