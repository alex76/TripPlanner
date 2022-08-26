import Foundation

public enum LocalCode: String, Identifiable, CaseIterable {
    case en

    public var id: String { self.rawValue }

    public static var preferred: Self {
        guard let longCode = Bundle.main.preferredLocalizations.first,
            let code = longCode.components(separatedBy: "-").first
        else { return .en }
        return Self.init(rawValue: code) ?? .en
    }
}
