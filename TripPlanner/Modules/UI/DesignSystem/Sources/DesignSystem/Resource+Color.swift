import Foundation
import SwiftUI
import UIKit

extension Resource {
    public enum Color: String {
        case black
        case white
        case gray
        case grayBackground
        case grayBorder
    }
}

// MARK: - System predefined colors
// NOTE: The visible color pallet can be seen https://stackoverflow.com/questions/56466128/what-are-the-primary-and-secondary-colors-in-swiftui
// or in the project Examples
extension Color {

    // MARK: - Text Colors
    public static let lightText = Color(UIColor.lightText)
    public static let darkText = Color(UIColor.darkText)
    public static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors
    public static let label = Color(UIColor.label)
    public static let secondaryLabel = Color(UIColor.secondaryLabel)
    public static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    public static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors
    public static let systemBackground = Color(UIColor.systemBackground)
    public static let secondarySystemBackground = Color(
        UIColor.secondarySystemBackground
    )
    public static let tertiarySystemBackground = Color(
        UIColor.tertiarySystemBackground
    )

    // MARK: - Fill Colors
    public static let systemFill = Color(UIColor.systemFill)
    public static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    public static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    public static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)

    // MARK: - Grouped Background Colors
    public static let systemGroupedBackground = Color(
        UIColor.systemGroupedBackground
    )
    public static let secondarySystemGroupedBackground = Color(
        UIColor.secondarySystemGroupedBackground
    )
    public static let tertiarySystemGroupedBackground = Color(
        UIColor.tertiarySystemGroupedBackground
    )

    // MARK: - Gray Colors
    public static let systemGray = Color(UIColor.systemGray)
    public static let systemGray2 = Color(UIColor.systemGray2)
    public static let systemGray3 = Color(UIColor.systemGray3)
    public static let systemGray4 = Color(UIColor.systemGray4)
    public static let systemGray5 = Color(UIColor.systemGray5)
    public static let systemGray6 = Color(UIColor.systemGray6)

    // MARK: - Other Colors
    public static let separator = Color(UIColor.separator)
    public static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    public static let link = Color(UIColor.link)

    // MARK: System Colors
    public static let systemBlue = Color(UIColor.systemBlue)
    public static let systemPurple = Color(UIColor.systemPurple)
    public static let systemGreen = Color(UIColor.systemGreen)
    public static let systemYellow = Color(UIColor.systemYellow)
    public static let systemOrange = Color(UIColor.systemOrange)
    public static let systemPink = Color(UIColor.systemPink)
    public static let systemRed = Color(UIColor.systemRed)
    public static let systemTeal = Color(UIColor.systemTeal)
    public static let systemIndigo = Color(UIColor.systemIndigo)

}
