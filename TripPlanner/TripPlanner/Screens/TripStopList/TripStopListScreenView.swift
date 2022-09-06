import DesignSystem
import SwiftUI

struct TripStopListScreenView<
    ViewModel: TripStopListViewModelProtocol & TripStopListFlowStateProtocol
>: View {
    private typealias Localization = Resource.Text.TripList

    @StateObject var viewModel: ViewModel

    var body: some View {
        TripStopListFlowCoordinator(state: viewModel, content: content)
    }

    @ViewBuilder
    private func content() -> some View {
        VStack(spacing: Theme.space.s0) {
            TripStopListHeader(
                departureName: viewModel.trip.connections.first?.source.name ?? "",
                arrivalName: viewModel.trip.connections.last?.destination.name ?? "",
                price: viewModel.trip.price
            )
            .padding(.top, Theme.space.s2)
            .padding([.bottom, .horizontal], Theme.space.s4)
            .background(Color(from: .blueTranslucent).background(.ultraThinMaterial))

            List(viewModel.trip.connections, id: \.self) { connection in
                TripListCell(
                    departure: connection.source.name,
                    arrival: connection.destination.name,
                    stops: 0,
                    price: connection.price,
                    backgroundColor: Color(from: .blueTranslucent).opacity(0.05),
                    borderColor: Color(from: .grayBorder),
                    showBadge: false,
                    showArrow: false,
                    didSelect: {}
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(
                    EdgeInsets(
                        top: Theme.space.s2,
                        leading: Theme.space.s4,
                        bottom: Theme.space.s2,
                        trailing: Theme.space.s4
                    )
                )
            }
            .listStyle(.plain)
        }
    }
}

#if DEBUG
    struct TripStopListScreenView_Previews: PreviewProvider {
        static var previews: some View {
            TripStopListScreenView<TripStopListViewModel>(
                viewModel: .preview
            )
        }
    }
#endif
