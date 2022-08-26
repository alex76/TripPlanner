import DesignSystem
import Foundation
import SwiftUI

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
                    verbatim: viewModel.sourceCity?.name ?? Localization.selectCity.localized,
                    action: { [weak viewModel] in
                        guard let viewModel = viewModel else { return }
                        viewModel.openCityPicker(for: $viewModel.sourceCity)
                    }
                )
                CapsuleButton(
                    verbatim: viewModel.destinationCity?.name ?? Localization.selectCity.localized,
                    action: { [weak viewModel] in
                        guard let viewModel = viewModel else { return }
                        viewModel.openCityPicker(for: $viewModel.destinationCity)
                    }
                )

                Spacer()
            }
            .padding(Theme.space.s4)
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
