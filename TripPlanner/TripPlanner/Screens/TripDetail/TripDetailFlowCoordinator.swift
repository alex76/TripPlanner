import Core
import Repository
import SwiftUI

// MARK: - TripDetailFlowStateProtocol
protocol TripDetailFlowStateProtocol: ObservableObject {
    var route: TripDetailRoute? { get set }

    func openMap(for connections: [Connection])
}

// MARK: - TripDetailRoute
enum TripDetailRoute: Identifiable {
    case map([Connection])

    var id: Int {
        switch self {
        case .map(let connections):
            var hasher = Hasher()
            hasher.combine("map")
            hasher.combine(connections)
            return hasher.finalize()
        }
    }

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
            .sheet(item: activeSheet, content: sheetDestination)
    }

    // MARK: Destinations
    @ViewBuilder
    private func sheetDestination(_ route: TripDetailRoute) -> some View {
        switch route {
        case .map(let connections):
            MapScreenView(
                viewModel: MapViewModel(connections: connections)
            )
        }
    }
}
