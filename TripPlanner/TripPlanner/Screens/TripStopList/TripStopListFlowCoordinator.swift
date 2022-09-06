import Core
import Repository
import SwiftUI
import SwiftUINavigation

// MARK: - TripStopListFlowStateProtocol
protocol TripStopListFlowStateProtocol: ObservableObject {
    var route: TripStopListRoute? { get set }

    func openMap(for connection: Connection)
}

// MARK: - TripStopListRoute
enum TripStopListRoute {
    case map
}

// MARK: - TripStopListFlowCoordinator
struct TripStopListFlowCoordinator<
    State: TripStopListFlowStateProtocol,
    Content: View
>: View {
    @EnvironmentObject var container: DIContainer

    @ObservedObject var state: State

    let content: () -> Content

    var body: some View {
        content()
    }
}
