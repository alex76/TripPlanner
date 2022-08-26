import Foundation
import SwiftUI

/// Case less enum. Wrapper for the all resources kinds.
public enum Resource {}

extension Color {
    public init(from color: Resource.Color) {
        self.init(color.rawValue, bundle: .module)
    }
}

extension Text {
    public init(from text: Resource.Text) {
        self.init(text.localized)
    }
}
