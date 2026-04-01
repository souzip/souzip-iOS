import Domain
import Foundation

public enum CountryDTOMapper {
    public static func toDomain(_ dto: GeocodingAddressResponse) -> GeocodingAddress {
        GeocodingAddress(
            formattedAddress: dto.formattedAddress,
            city: dto.city,
            countryCode: dto.countryCode
        )
    }

    public static func toDomain(
        _ items: [LocationSearchItemResponse]
    ) -> [LocationSearchHit] {
        items.map { mapLocationSearchItem($0) }
    }

    // MARK: - Location search (GET /api/location/search)

    private static func mapLocationSearchItem(
        _ item: LocationSearchItemResponse
    ) -> LocationSearchHit {
        let coordinate = Coordinate(
            latitude: item.coordinate.latitude,
            longitude: item.coordinate.longitude
        )
        let id = makeLocationSearchHitID(
            typeToken: item.type,
            title: item.name,
            coordinate: coordinate
        )

        switch item.type.lowercased() {
        case "place":
            let kindLabel = GooglePlaceTypeKoreanMapping.koreanLabel(forAPIValue: item.category)
            let placeKind: String? = kindLabel.isEmpty ? nil : kindLabel
            let areaDescription = Self.nonEmptyTrimmed(item.region) ?? Self.nonEmptyTrimmed(item.address)
            return .place(
                PlaceSearchHit(
                    id: id,
                    title: item.name,
                    placeKind: placeKind,
                    areaDescription: areaDescription,
                    coordinate: coordinate
                )
            )

        case "city":
            return .city(
                CitySearchHit(
                    id: id,
                    title: item.name,
                    countryLine: item.country,
                    coordinate: coordinate
                )
            )

        default:
            return .city(
                CitySearchHit(
                    id: id,
                    title: item.name,
                    countryLine: item.country,
                    coordinate: coordinate
                )
            )
        }
    }

    private static func nonEmptyTrimmed(_ raw: String?) -> String? {
        guard let raw else { return nil }
        let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }

    private static func makeLocationSearchHitID(
        typeToken: String,
        title: String,
        coordinate: Coordinate
    ) -> LocationSearchHitID {
        let lat = String(format: "%.5f", coordinate.latitude)
        let lon = String(format: "%.5f", coordinate.longitude)
        return LocationSearchHitID(rawValue: "\(typeToken)-\(title)-\(lat)-\(lon)")
    }
}
