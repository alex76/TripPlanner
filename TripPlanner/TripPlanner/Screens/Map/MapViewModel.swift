import Core
import Foundation
import MapKit
import Repository
import Utilities

// MARK: - AnnotationItem
struct AnnotationItem: Identifiable {
    let id: Int
    let city: City
}

// MARK: - MapViewModelProtocol
protocol MapViewModelProtocol: ObservableObject {
    var connections: [Connection] { get }
    var mapRegion: MKCoordinateRegion { get set }
    var annotationItems: [AnnotationItem] { get }
}

// MARK: - MapViewModel
final class MapViewModel: BaseViewModel, MapViewModelProtocol {

    private static let defaultRegion = MKCoordinateRegion(
        center: .init(latitude: 51.5, longitude: -0.12),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    init(connections: [Connection]) {
        self.connections = connections
        self.annotationItems = connections.cities.enumerated().map {
            AnnotationItem(id: $0.offset.advanced(by: 1), city: $0.element)
        }
        self.mapRegion =
            MKCoordinateRegion(coordinates: connections.cities.locationCoordinates)
            ?? Self.defaultRegion
    }

    // MARK: - ViewModelProtocol
    let annotationItems: [AnnotationItem]
    @Published private(set) var connections: [Connection]
    @Published var mapRegion: MKCoordinateRegion

}

extension City.Coordinate {
    var locationCoordinate: CLLocationCoordinate2D {
        .init(latitude: lat, longitude: long)
    }
}

extension Array where Element == City {
    var locationCoordinates: [CLLocationCoordinate2D] {
        self.map(\.coordinate.locationCoordinate)
    }
}

#if DEBUG
    extension MapViewModel {
        static var preview: Self {
            .init(connections: MockData.Trip.data.connections)
        }
    }
#endif
