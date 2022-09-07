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

    var modal: TripDetailRoute? {
        switch self {
        case .map: return self
        }
    }
}

// MARK: - TripDetailFlowCoordinator
struct TripDetailFlowCoordinator<
    State: TripDetailFlowStateProtocol,
    Content: View
>: View {
    @EnvironmentObject var container: DIContainer

    @ObservedObject var state: State

    let content: () -> Content

    private var activeSheet: Binding<TripDetailRoute?> {
        $state.route.map(get: { $0?.modal }, set: { $0 })
    }

    var body: some View {
        content()
            .sheet(
                unwrapping: activeSheet,
                case: /TripDetailRoute.map,
                content: mapDestination
            )
    }

    // MARK: Destinations
    @ViewBuilder
    private func mapDestination(_ value: Binding<[Connection]>) -> some View {
        MapScreenView(
            viewModel: MapViewModel(connections: value.wrappedValue)
        )
    }
}
