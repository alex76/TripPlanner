import DesignSystem
import MapKit
import SwiftUI

struct MapScreenView<
    ViewModel: MapViewModelProtocol
>: View {

    @StateObject var viewModel: ViewModel

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            Map(
                coordinateRegion: $viewModel.mapRegion,
                annotationItems: viewModel.annotationItems
            ) { item in
                MapAnnotation(coordinate: item.city.coordinate.locationCoordinate) {
                    let fillColor =
                        (item.id == 1 || item.id == viewModel.annotationItems.count)
                        ? Color.red : Color.gray
                    Circle()
                        .fill(fillColor)
                        .frame(width: 35, height: 35)
                        .overlay {
                            switch item.id {
                            case 1:
                                VStack {
                                    Image(systemName: "play")
                                        .font(.system(size: 11)).foregroundColor(.white)
                                    Text(verbatim: String(item.id))
                                        .font(.system(size: 9)).foregroundColor(.white)
                                }
                            case viewModel.annotationItems.count:
                                VStack {
                                    Image(systemName: "flag.2.crossed")
                                        .font(.system(size: 11)).foregroundColor(.white)
                                    Text(verbatim: String(item.id))
                                        .font(.system(size: 9)).foregroundColor(.white)
                                }
                            default:
                                Text(verbatim: String(item.id))
                                    .font(.system(size: 11)).foregroundColor(.white)
                            }
                        }
                }
            }
            .toolbar {
                Button(Resource.Text.close.localized) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle(
                "\(viewModel.connections.first?.source.name ?? "") ➡︎ \(viewModel.connections.last?.destination.name ?? "")"
            )
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
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
