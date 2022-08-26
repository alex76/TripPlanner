import Core
import Repository
import SwiftUI
import Utilities

// MARK: - TripListFlowStateProtocol
protocol TripListFlowStateProtocol: ObservableObject {
    var route: TripListRoute? { get set }

    func openCityPicker(for city: Binding<City?>)
}

// MARK: - Route
enum TripListRoute: Identifiable {
    case cityPicker(Binding<City?>)

    var id: Int {
        switch self {
        case .cityPicker(let binding):
            return binding.wrappedValue.hashValue
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
        content()
            .sheet(
                item: activeSheet,
                content: { route in
                    if let tripRepository = container.tripRepository {
                        switch route {
                        case .cityPicker(let binding):
                            CityPickerScreenView(
                                viewModel: CityPickerViewModel(
                                    repository: tripRepository,
                                    city: binding
                                )
                            )
                        }
                    }
                }
            )
    }
}
