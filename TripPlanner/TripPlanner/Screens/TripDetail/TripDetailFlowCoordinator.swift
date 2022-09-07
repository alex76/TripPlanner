import Core
import Repository
import SwiftUI
import SwiftUINavigation

// MARK: - TripDetailFlowStateProtocol
protocol TripDetailFlowStateProtocol: ObservableObject {
    var route: TripDetailRoute? { get set }

    func openMap(for connections: [Connection])
}

// MARK: - TripDetailRoute
enum TripDetailRoute {
    case map([Connection])
}

// MARK: - TripDetailFlowCoordinator
struct TripDetailFlowCoordinator<
    State: TripDetailFlowStateProtocol,
    Content: View
>: View {
    @EnvironmentObject var container: DIContainer

    @ObservedObject var state: State

    let content: () -> Content

    var body: some View {
        content()
    }
}
