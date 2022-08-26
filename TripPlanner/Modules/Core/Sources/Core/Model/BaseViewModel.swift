import Foundation

open class BaseViewModel {

    public init() {
        debugPrint("💡 init ViewModel [\(String(describing: self))]")
    }

    deinit {
        debugPrint("♻️ deinit ViewModel [\(String(describing: self))]")
    }

}
