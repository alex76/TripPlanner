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
            VStack {
                CapsuleButton(
                    verbatim: viewModel.departureCity?.name ?? Localization.selectCity.localized,
                    action: { [weak viewModel] in
                        guard let viewModel = viewModel else { return }
                        viewModel.openCityPicker(for: $viewModel.departureCity, type: .departure)
                    }
                )
                CapsuleButton(
                    verbatim: viewModel.arrivalCity?.name ?? Localization.selectCity.localized,
                    action: { [weak viewModel] in
                        guard let viewModel = viewModel else { return }
                        viewModel.openCityPicker(for: $viewModel.arrivalCity, type: .arrival)
                    }
                )

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
            .padding(Theme.space.s4)
        }
    }

    @ViewBuilder
    private func tripSection() -> some View {
        VStack {
            TextView(localizedEnum: Localization.foundTrips, .headline)
                .padding(.top, Theme.space.s6)
            List(viewModel.trips, id: \.self) { trip in
                VStack {
                    HStack {
                        (TextView(verbatim: trip.connections.first?.source.name ?? "-")
                            + TextView(verbatim: " -> ")
                            + TextView(verbatim: trip.connections.last?.destination.name ?? "-"))
                            .fontWeight(.bold)

                        Spacer()
                        TextView(
                            verbatim:
                                "\(Localization.price.localized): \(trip.price.rounded(toPlaces: 2))"
                        )
                        .fontWeight(.bold)
                    }

                    let stops = trip.connections.stops.map(\.name).joined(separator: " -> ")
                    TextView(verbatim: stops, .caption1)
                        .leadingAligned()
                }
                .padding(.vertical, Theme.space.s3)
            }
        }
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
