import Core
import DesignSystem
import Repository
import SwiftUI
import Utilities

// MARK: - TripListFlowStateProtocol
protocol TripListFlowStateProtocol: ObservableObject {
    var route: TripListRoute? { get set }

    func openCityPicker(for city: Binding<City?>, type: DestinationType)
    func openTrip(_ trip: Trip)
}

// MARK: - Route
enum TripListRoute: Identifiable {
    case cityPicker(city: Binding<City?>, type: DestinationType)
    case tripDetail(Trip)

    var id: Int {
        var hasher = Hasher()
        switch self {
        case .cityPicker(let city, let type):
            hasher.combine("cityPicker")
            hasher.combine(city.wrappedValue)
            hasher.combine(type)
        case .tripDetail(let trip):
            hasher.combine("tripDetail")
            hasher.combine(trip)
        }
        return hasher.finalize()
    }

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

    private var activeLink: Binding<Bool> {
        .init(
            get: { [weak state] in
                state?.route?.navigationLink != nil
            },
            set: { [weak state] value in
                if value == false && state?.route?.navigationLink != nil {
                    state?.route = nil
                }
            }
        )
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
        .sheet(item: activeSheet, content: sheetDestinations)
    }

    @ViewBuilder private var navigationLinks: some View {
        ZStack {
            NavigationLink(
                isActive: activeLink,
                destination: { [weak state] in
                    if let link = state?.route?.navigationLink {
                        navigationDestinations(link)
                    }
                },
                label: { EmptyView() }
            )
        }
    }

    // MARK: - Destinations
    @ViewBuilder
    private func navigationDestinations(_ route: TripListRoute) -> some View {
        switch route {
        case .tripDetail(let trip):
            TripDetailScreenView(
                viewModel: TripDetailViewModel(trip: trip)
            )
        default: EmptyView()

        }
    }

    @ViewBuilder
    private func sheetDestinations(
        _ route: TripListRoute
    ) -> some View {
        switch route {
        case .cityPicker(let city, let type):
            if let repository = container.tripRepository {
                CityPickerScreenView(
                    viewModel: CityPickerViewModel(
                        repository: repository,
                        city: city
                    ),
                    type: type
                )
            }
        default: EmptyView()
        }
    }
}
