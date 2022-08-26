import Core
import DesignSystem
import SwiftUI

struct CityPickerScreenView<
    ViewModel: CityPickerViewModelProtocol
>: View {
    private typealias Localization = Resource.Text.Citypicker

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @StateObject var viewModel: ViewModel

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
                        TextView(verbatim: city.name)
                    }
                }
                .overlay {
                    if cities.isEmpty {
                        TextView(localizedEnum: Localization.noCityAvailable)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: Localization.lookForACity.localized)
            .navigationTitle(Localization.cityPicker.localized)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
    struct CityPickerScreenView_Previews: PreviewProvider {
        static var previews: some View {
            CityPickerScreenView<CityPickerViewModel>(
                viewModel: .preview
            )
        }
    }
#endif
