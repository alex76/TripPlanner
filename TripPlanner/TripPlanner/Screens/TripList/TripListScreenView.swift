import DesignSystem
import Foundation
import SwiftUI
import Utilities

struct TripListScreenView<
    ViewModel: TripListViewModelProtocol & TripListFlowStateProtocol
>: View {
    private typealias Localization = Resource.Text.TripList

    @StateObject var viewModel: ViewModel

    var body: some View {
        TripListFlowCoordinator(state: viewModel, content: content)
    }

    @ViewBuilder
    private func content() -> some View {
        LoaderView(
            requestState: viewModel.connectionRequest,
            onNotAsked: { viewModel.reloadConnections() }
        ) {
            VStack(spacing: Theme.space.s0) {
                TripListHeader(
                    departureName: viewModel.departureCity?.name,
                    arrivalName: viewModel.arrivalCity?.name,
                    onSelectDeparture: { [weak viewModel] in
                        guard let viewModel = viewModel else { return }
                        viewModel.openCityPicker(for: $viewModel.departureCity, type: .departure)
                    },
                    onSelectArrival: { [weak viewModel] in
                        guard let viewModel = viewModel else { return }
                        viewModel.openCityPicker(for: $viewModel.arrivalCity, type: .arrival)
                    },
                    onSwapDestinations: { [weak viewModel] in viewModel?.swapDestinations() }
                )
                .padding(.top, Theme.space.s2)
                .padding([.bottom, .horizontal], Theme.space.s4)
                .background(Color(from: .blueTranslucent).background(.ultraThinMaterial))

                if let source = viewModel.departureCity,
                    let destination = viewModel.arrivalCity
                {
                    if source == destination {
                        TextView(localizedEnum: Localization.sameCities, .headline)
                            .padding(.top, Theme.space.s6)
                    } else if !viewModel.trips.isEmpty {
                        tripSection()
                    } else {
                        TextView(localizedEnum: Localization.noTripsBetweenCities, .headline)
                            .padding(.top, Theme.space.s6)
                    }
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Localization.connection.localized)
    }

    @ViewBuilder
    private func tripSection() -> some View {
        List(viewModel.trips, id: \.self) { trip in
            TripListCell(
                departure: trip.connections.first?.source.name ?? "-",
                arrival: trip.connections.last?.destination.name ?? "-",
                stops: trip.connections.stops.count - 2,
                price: trip.price,
                backgroundColor: Color(from: .blueTranslucent).opacity(0.05),
                borderColor: Color(from: .grayBorder),
                didSelect: { [weak viewModel] in viewModel?.openTrip(trip) }
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

#if DEBUG
    struct TripListScreenView_Previews: PreviewProvider {
        static var previews: some View {
            TripListScreenView<TripListViewModel>(
                viewModel: .preview
            )
        }
    }
#endif
