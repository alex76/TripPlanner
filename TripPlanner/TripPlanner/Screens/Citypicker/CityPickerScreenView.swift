import Core
import DesignSystem
import SwiftUI

struct CityPickerScreenView<
    ViewModel: CityPickerViewModelProtocol
>: View {
    private typealias Localization = Resource.Text.Citypicker

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @StateObject var viewModel: ViewModel
    let type: DestinationType

    var body: some View {
        NavigationView {
            LoaderView(
                requestState: viewModel.citiesRequest,
                onNotAsked: { viewModel.loadData(for: "") }
            ) { cities in
                List(cities, id: \.self) { city in
                    ClearButton(action: { [weak viewModel] in
                        viewModel?.didSelectCity(city)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack(alignment: .leading) {
                            Color.clear.contentShape(Rectangle())
                            TextView(verbatim: city.name)
                        }
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity)
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if cities.isEmpty {
                        TextView(localizedEnum: Localization.noCityAvailable)
                    }
                }
            }
            .toolbar {
                Button(Localization.close.localized) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Localization.searchTheCity.localized
            )
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(
                type == .departure
                    ? Localization.selectDeparture.localized
                    : Localization.selectArrival.localized
            )
        }
        .navigationAppearance(
            backgroundColor: .blue,
            foregroundColor: .white,
            tintColor: .white,
            hideSeparator: true
        )
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
    struct CityPickerScreenView_Previews: PreviewProvider {
        static var previews: some View {
            CityPickerScreenView<CityPickerViewModel>(
                viewModel: .preview,
                type: .departure
            )
        }
    }
#endif
