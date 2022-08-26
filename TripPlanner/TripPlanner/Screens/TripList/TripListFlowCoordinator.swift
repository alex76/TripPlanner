import SwiftUI

// MARK: - TripListFlowStateProtocol
protocol TripListFlowStateProtocol: ObservableObject {
    var route: TripListRoute? { get set }
}

// MARK: - Route
enum TripListRoute {

}

// MARK: - TripListFlowCoordinator
struct TripListFlowCoordinator<
    State: TripListFlowStateProtocol,
    Content: View
>: View {

    @ObservedObject var state: State

    let content: () -> Content

    var body: some View {
        content()
    }
}
