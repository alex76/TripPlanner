import DesignSystem
import SwiftUI

struct MapScreenView<
    ViewModel: MapViewModelProtocol
>: View {

    @StateObject var viewModel: ViewModel

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            Color.yellow
                .toolbar {
                    Button(Resource.Text.close.localized) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .navigationTitle(
                    "\(viewModel.connections.first?.source.name ?? "") ➡︎ \(viewModel.connections.last?.destination.name ?? "")"
                )
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .blueNavigationAppearance()
    }
}

#if DEBUG
    struct MapScreenView_Previews: PreviewProvider {
        static var previews: some View {
            MapScreenView<MapViewModel>(
                viewModel: .preview
            )
        }
    }
#endif
