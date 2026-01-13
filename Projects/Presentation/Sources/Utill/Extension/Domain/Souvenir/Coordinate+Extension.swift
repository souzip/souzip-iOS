import CoreLocation
import Domain

extension Coordinate {
    var toCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D {
    var toCoordinate: Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }

    func rounded(toDecimalPlaces places: Int) -> CLLocationCoordinate2D {
        let multiplier = pow(10.0, Double(places))
        return CLLocationCoordinate2D(
            latitude: Double(Int(latitude * multiplier)) / multiplier,
            longitude: Double(Int(longitude * multiplier)) / multiplier
        )
    }
}
