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
}
