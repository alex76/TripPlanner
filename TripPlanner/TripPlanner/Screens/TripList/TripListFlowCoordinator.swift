import Core
import DesignSystem
import Repository
import SwiftUI
import SwiftUINavigation
import Utilities

// MARK: - TripListFlowStateProtocol
protocol TripListFlowStateProtocol: ObservableObject {
    var route: TripListRoute? { get set }

    func openCityPicker(for city: Binding<City?>, type: DestinationType)
    func openTrip(_ trip: Trip)
}

// MARK: - Route
enum TripListRoute {
    case cityPicker(city: Binding<City?>, type: DestinationType)
    case tripDetail(Trip)

    var navigationLink: TripListRoute? {
        switch self {
        case .tripDetail: return self
        default: return nil
        }
    }

    var modal: TripListRoute? {
        switch self {
        case .cityPicker: return self
        default: return nil
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

    private var activeLink: Binding<TripListRoute?> {
        $state.route.map(get: { $0?.navigationLink }, set: { $0 })
    }

    var body: some View {
        NavigationView {
            ZStack {
                content()
                navigationLinks
            }
        }
        .navigationViewStyle(.stack)
        .blueNavigationAppearance()
        .sheet(
            unwrapping: activeSheet,
            case: /TripListRoute.cityPicker,
            content: cityPickerDestination
        )
    }

    @ViewBuilder private var navigationLinks: some View {
        ZStack {
            NavigationLink(
                unwrapping: activeLink,
                case: /TripListRoute.tripDetail,
                destination: tripDetailDestination,
                onNavigate: { _ in },
                label: { EmptyView() }
            )
        }
    }

    // MARK: - Destinations
    @ViewBuilder
    private func tripDetailDestination(_ value: Binding<Trip>) -> some View {
        TripStopListScreenView(
            viewModel: TripStopListViewModel(trip: value.wrappedValue)
        )
    }

    @ViewBuilder
    private func cityPickerDestination(
        _ value: Binding<(city: Binding<City?>, type: DestinationType)>
    ) -> some View {
        IfLet(.constant(container.tripRepository)) { $repository in
            CityPickerScreenView(
                viewModel: CityPickerViewModel(
                    repository: repository,
                    city: value.wrappedValue.city
                ),
                type: value.wrappedValue.type
            )
        }
    }
}
