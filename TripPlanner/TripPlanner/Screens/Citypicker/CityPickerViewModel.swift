import Combine
import Core
import Foundation
import Repository
import SwiftUI
import Utilities

// MARK: - CityPickerViewModelProtocol
protocol CityPickerViewModelProtocol: ObservableObject {
    typealias ModelType = City

    var citiesRequest: RequestState<[ModelType]> { get }
    var searchText: String { get set }

    func loadData(for searchTerm: String)
    func didSelectCity(_ city: City)
}

// MARK: - CityPickerViewModel
final class CityPickerViewModel: BaseViewModel, CityPickerViewModelProtocol {

    private let repository: TripRepositoryProtocol
    private var loadingCancellables: Set<AnyCancellable> = .init()
    private var cancellables: Set<AnyCancellable> = .init()

    @Binding private var city: City?

    init(
        repository: TripRepositoryProtocol,
        city: Binding<City?>
    ) {
        self.repository = repository
        self._city = city

        super.init()
        self.setupSubscriptions()
    }

    private func setupSubscriptions() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.loadData(for: $0)
            })
            .store(in: &cancellables)
    }

    // MARK: - ViewModelProtocol
    @Published private(set) var citiesRequest: RequestState<[ModelType]> = .notAsked
    @Published var searchText: String = ""

    func loadData(for searchTerm: String) {
        loadingCancellables.cancelAll()
        citiesRequest = .loading(last: citiesRequest.data)

        let task: Single<[City], Error>
        if searchTerm.isEmpty {
            task = repository.fetchCities()
        } else {
            task = repository.fetchCities(for: searchTerm)
        }

        task
            .sinkToResult { [weak self] result in
                switch result {
                case .success(let cities):
                    let sortedCities = cities.sorted(by: { $0.name < $1.name })
                    self?.citiesRequest = .success(sortedCities)
                case .failure(let error):
                    self?.citiesRequest = .failure(error)
                }
            }
            .store(in: &loadingCancellables)
    }

    func didSelectCity(_ city: City) {
        self.city = city
    }
}

#if DEBUG
    extension CityPickerViewModel {
        static var preview: Self {
            .init(repository: .mock, city: .constant(nil))
        }
    }
#endif
