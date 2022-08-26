import Foundation
import SwiftUI

// MARK: - Text extensions
public protocol LocalizedEnum: RawRepresentable where RawValue == String {
    static var prefix: String { get }
}

extension LocalizedEnum {
    public var localized: String {
        self.key.localized()
    }

    public func localized(code: LocalCode = .preferred) -> String {
        self.key.localized(code: code)
    }

    public var key: String {
        return Self.prefix + self.rawValue
    }
}

extension String {
    public var localized: String {
        self.localized(code: .preferred)
    }

    public func localized(
        code: LocalCode = .preferred,
        bundle: Bundle? = nil
    ) -> String {
        let bundle = bundle ?? .module
        let language = code.rawValue
        guard
            let path = bundle.path(
                forResource: language,
                ofType: "lproj"
            )
                ?? bundle.path(
                    forResource: LocalCode.en.rawValue,
                    ofType: "lproj"
                ),
            let bundle = Bundle(path: path)
        else { return self }
        let localized = bundle.localizedString(
            forKey: self,
            value: nil,
            table: nil
        )
        if localized == self {
            print(
                "📘❕: Localization missing: \"\(self)\"=\"\(localized)\";"
            )
        }
        return localized
    }
}

extension LocalizedStringKey {}
