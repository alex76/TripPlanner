import Core
import DesignSystem
import Repository
import SwiftUI
import Utilities

// MARK: - TripListFlowStateProtocol
protocol TripListFlowStateProtocol: ObservableObject {
    var route: TripListRoute? { get set }

    func openCityPicker(for city: Binding<City?>, type: DestinationType)
}

// MARK: - Route
enum TripListRoute: Identifiable {
    case cityPicker(Binding<City?>, type: DestinationType)

    var id: Int {
        switch self {
        case .cityPicker(let city, let type):
            var hasher = Hasher()
            hasher.combine(city.wrappedValue)
            hasher.combine(type)
            return hasher.finalize()
        }
    }

    var modal: TripListRoute? {
        switch self {
        case .cityPicker:
            return self
        }
    }
}

// MARK: - TripListFlowCoordinator
struct TripListFlowCoordinator<
    State: TripListFlowStateProtocol,
    Content: View
>: View {
    @EnvironmentObject var container: DIContainer

    @ObservedObject var state: State

    let content: () -> Content

    private var activeSheet: Binding<TripListRoute?> {
        $state.route.map(get: { $0?.modal }, set: { $0 })
    }

    var body: some View {
        NavigationView {
            content()
        }
        .navigationViewStyle(.stack)
        .blueNavigationAppearance()
        .modalRoute(for: activeSheet, container: container)
    }
}

// MARK: - Private Helpers
extension View {
    @ViewBuilder
    fileprivate func modalRoute(
        for activeSheet: Binding<TripListRoute?>,
        container: DIContainer
    ) -> some View {
        self.sheet(
            item: activeSheet,
            content: { route in
                if let tripRepository = container.tripRepository {
                    switch route {
                    case .cityPicker(let city, let type):
                        CityPickerScreenView(
                            viewModel: CityPickerViewModel(
                                repository: tripRepository,
                                city: city
                            ),
                            type: type
                        )
                    }
                }
            }
        )
    }
}
