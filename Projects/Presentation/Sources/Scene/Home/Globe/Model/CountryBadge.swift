import CoreLocation
import Domain
import UIKit

struct CountryBadge: Equatable {
    let coordinate: CLLocationCoordinate2D
    let countryName: String
    let imageURL: String
    let color: UIColor

    static func == (lhs: CountryBadge, rhs: CountryBadge) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
            lhs.coordinate.longitude == rhs.coordinate.longitude &&
            lhs.countryName == rhs.countryName
    }
}

extension CountryBadge {
    static let colors: [UIColor] = [
        .dsMain,
        .dsSecondaryYellow,
        .dsSecondaryGreen,
        .dsSecondaryPurple,
        .dsSecondaryBlue,
    ]

    private static func color(for key: String) -> UIColor {
        let index = abs(key.hashValue) % colors.count
        return colors[index]
    }

    init(country: CountryDetail) {
        coordinate = country.coordinate.toCLLocationCoordinate2D
        countryName = country.nameKorean
        imageURL = country.flagImageURL
        color = Self.color(for: country.nameKorean)
    }
}
