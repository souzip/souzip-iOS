import Domain

public enum CountryDTOMapper {
    public static func toDomain(_ dto: GeocodingAddressResponse) -> GeocodingAddress {
        GeocodingAddress(
            formattedAddress: dto.formattedAddress,
            city: dto.city,
            countryCode: dto.countryCode
        )
    }

    public static func toDomain(_ dto: SearchLocationsResponse) -> [SearchedLocation] {
        dto.content.map { item in
            SearchedLocation(
                id: item.id,
                type: LocationType(rawValue: item.type) ?? .city,
                name: item.name,
                nameEn: item.nameEn,
                nameKr: item.nameKr,
                countryName: item.countryName,
                countryNameEn: item.countryNameEn,
                countryNameKr: item.countryNameKr,
                score: item.score,
                highlight: item.highlight.raw,
                coordinate: Coordinate(
                    latitude: item.latitude,
                    longitude: item.longitude
                )
            )
        }
    }
}
