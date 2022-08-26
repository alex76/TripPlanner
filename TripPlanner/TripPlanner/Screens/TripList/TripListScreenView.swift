import DesignSystem
import Foundation
import SwiftUI

struct TripListScreenView<
    ViewModel: TripListViewModelProtocol & TripListFlowStateProtocol
>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        TripListFlowCoordinator(state: viewModel, content: content)
    }

    @ViewBuilder
    private func content() -> some View {
        Color(from: .black)
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
