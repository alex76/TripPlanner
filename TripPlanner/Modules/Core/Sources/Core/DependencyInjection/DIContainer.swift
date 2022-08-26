import Combine
import Foundation

// MARK: - DIContainer
public typealias Store<State> = CurrentValueSubject<State, Never>

public class DIContainer: ObservableObject {

    public var configurations: Configurations
    public var services: Services

    public init(
        configurations: Configurations? = nil,
        services: Services? = nil
    ) {
        self.configurations = configurations ?? Configurations()
        self.services = services ?? Services()
    }

}

// MARK: - DIContainer: Configurations
extension DIContainer {

    public struct Configurations {
        public typealias ConfigPublisher<T> = AnyPublisher<T, Never>

        private var storage: [String: Store<ConfigurationProtocol>]

        public init() {
            self.storage = [String: Store<ConfigurationProtocol>]()
        }

        public init(elements: [Store<ConfigurationProtocol>]) {
            var dictionary = [String: Store<ConfigurationProtocol>]()
            for element in elements {
                dictionary[String(describing: type(of: element.value))] =
                    element
            }
            self.storage = dictionary
        }

        public subscript<T>(type: T) -> T?
        where T: ConfigurationProtocol {
            get {
                let key = String(describing: type)
                return storage[key]?.value as? T
            }
            set {
                let key = String(describing: type)
                guard let config = newValue else {
                    storage[key] = nil
                    return
                }
                if let store = storage[key] {
                    store.value = config
                } else {
                    storage[key] = Store(config)
                }
            }
        }

        public func configPublisher<T>(
            ofType type: T.Type
        ) -> ConfigPublisher<T>? where T: ConfigurationProtocol {
            let key = String(describing: type)
            return storage[key]?
                .compactMap({ $0 as? T })
                .eraseToAnyPublisher()
        }
    }

}

// MARK: - DIContainer: Services
extension DIContainer {

    public struct Services {
        private var storage: [String: ServiceProtocol]

        public init() {
            self.storage = [String: ServiceProtocol]()
        }

        public init(elements: [ServiceProtocol]) {
            var dictionary = [String: ServiceProtocol]()
            for element in elements {
                dictionary[String(describing: type(of: element))] = element
            }
            self.storage = dictionary
        }

        public subscript<T>(type: T.Type) -> T?
        where T: ServiceProtocol {
            get {
                let key = String(describing: type)
                return storage[key] as? T
            }
            set {
                let key = String(describing: type)
                storage[key] = newValue
            }
        }

        // returns service based on protocol, it is necessary for stubs (there is stored different service but also conforming to protocol)
        public subscript<T>(type: T.Type) -> T? {
            let value = storage.first(where: { $1 is T })?.value
            return value as? T
        }
    }

}
