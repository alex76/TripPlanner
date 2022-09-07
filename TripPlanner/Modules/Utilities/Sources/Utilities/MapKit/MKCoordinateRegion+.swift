import MapKit

// reference: https://gist.github.com/dionc/46f7e7ee9db7dbd7bddec56bd5418ca6

extension MKCoordinateRegion {
    public init?(coordinates: [CLLocationCoordinate2D]) {
        // first create a region centered around the prime meridian
        let primeRegion = MKCoordinateRegion.region(
            for: coordinates,
            transform: { $0 },
            inverseTransform: { $0 }
        )

        // next create a region centered around the 180th meridian
        let transformedRegion = MKCoordinateRegion.region(
            for: coordinates,
            transform: MKCoordinateRegion.transform,
            inverseTransform: MKCoordinateRegion.inverseTransform
        )

        // return the region that has the smallest longitude delta
        if let a = primeRegion,
            let b = transformedRegion,
            let min = [a, b].min(by: { $0.span.longitudeDelta < $1.span.longitudeDelta })
        {
            self = min
        } else if let a = primeRegion {
            self = a
        } else if let b = transformedRegion {
            self = b
        } else {
            return nil
        }
    }

    // Latitude -180...180 -> 0...360
    private static func transform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude < 0 { return CLLocationCoordinate2DMake(c.latitude, 360 + c.longitude) }
        return c
    }

    // Latitude 0...360 -> -180...180
    private static func inverseTransform(c: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if c.longitude > 180 { return CLLocationCoordinate2DMake(c.latitude, -360 + c.longitude) }
        return c
    }

    private typealias Transform = (CLLocationCoordinate2D) -> (CLLocationCoordinate2D)

    private static func region(
        for coordinates: [CLLocationCoordinate2D],
        transform: Transform,
        inverseTransform: Transform
    ) -> MKCoordinateRegion? {
        // handle empty array
        guard !coordinates.isEmpty else { return nil }

        // handle single coordinate
        guard coordinates.count > 1 else {
            return MKCoordinateRegion(
                center: coordinates[0],
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            )
        }

        let maxZoom = MKCoordinateSpan(
            latitudeDelta: 135.68020269231502,
            longitudeDelta: 131.8359359933973
        )
        let minZoom = MKCoordinateSpan(
            latitudeDelta: 0.00033266201122472694,
            longitudeDelta: 0.00059856596270435602
        )

        let transformed = coordinates.map(transform)

        // find the span
        let minLat = transformed.min { $0.latitude < $1.latitude }!.latitude
        let maxLat = transformed.max { $0.latitude < $1.latitude }!.latitude
        let minLon = transformed.min { $0.longitude < $1.longitude }!.longitude
        let maxLon = transformed.max { $0.longitude < $1.longitude }!.longitude

        let zoomLat = (maxLat - minLat) * 1.8
        let zoomLon = (maxLon - minLon) * 1.8

        let span = MKCoordinateSpan(
            latitudeDelta: max(min(maxZoom.latitudeDelta, zoomLat), minZoom.latitudeDelta),
            longitudeDelta: max(min(maxZoom.longitudeDelta, zoomLon), minZoom.longitudeDelta)
        )

        // find the center of the span
        let center = inverseTransform(
            CLLocationCoordinate2DMake(
                maxLat - (maxLat - minLat) / 2,
                maxLon - (maxLon - minLon) / 2
            )
        )
        let region = MKCoordinateRegion(center: center, span: span)

        if let firstCoordinates = coordinates.first,
            !region.contains(firstCoordinates)
        {
            let newCenter = CLLocationCoordinate2DMake(
                firstCoordinates.latitude,
                firstCoordinates.longitude
            )
            return MKCoordinateRegion(center: newCenter, span: span)
        } else {
            return region
        }
    }
}

extension MKCoordinateRegion {
    fileprivate func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let lat =
            cos((center.latitude - coordinate.latitude) * Double.pi / 180.0)
            > cos(span.latitudeDelta / 2.0 * Double.pi / 180.0)
        let lon =
            cos((center.longitude - coordinate.longitude) * Double.pi / 180.0)
            > cos(span.longitudeDelta / 2.0 * Double.pi / 180.0)
        return lat && lon
    }
}
