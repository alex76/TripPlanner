import DesignSystem
import Foundation
import Repository
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
            onNotAsked: { viewModel.reloadConnections() },
            loadingView: { CircleLoadingView().eraseToAnyView() }
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

                tripSection()
                    .overlay {
                        if viewModel.isLoading {
                            CircleLoadingView()
                        } else if viewModel.trips.isEmpty {
                            TextView(localizedEnum: Localization.noTripsBetweenCities, .headline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(from: .gray))
                                .padding(.horizontal, Theme.space.s5)
                        }
                    }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Localization.tripPlanner.localized)
    }

    @ViewBuilder
    private func tripSection() -> some View {
        List {
            Section {
                ForEach(viewModel.trips, id: \.self) { trip in
                    TripListCell(
                        departure: trip.connections.first?.source.name ?? "-",
                        arrival: trip.connections.last?.destination.name ?? "-",
                        stops: trip.connections.cities.count - 2,
                        price: trip.price,
                        backgroundColor: Color(from: .blueTranslucent).opacity(0.05),
                        borderColor: Color(from: .grayBorder),
                        didSelect: { [weak viewModel] in viewModel?.openTrip(trip) },
                        disclosureIndicator: {
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 15))
                                .foregroundColor(Color(from: .black))
                        }
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
            } header: {
                if !viewModel.isLoading && !viewModel.trips.isEmpty {
                    TextView(
                        verbatim: viewModel.departureCity != nil && viewModel.arrivalCity != nil
                            ? Localization.foundTrips.localized : Localization.suggestions.localized
                    )
                    .foregroundColor(Color(from: .black))
                }
            }
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
