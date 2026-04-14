import Domain
import Foundation
import Logger

public enum CountryDTOMapper {
    // MARK: - Country (로컬 번들 / 국가 메타)

    public static func toDomain(_ dto: CountryDTO) -> CountryDetail {
        CountryDetail(
            nameEnglish: dto.nameEn,
            nameKorean: dto.nameKr,
            code: dto.code,
            region: toDomain(dto.region),
            capital: dto.capital ?? "",
            flagImageURL: dto.imageUrl,
            coordinate: Coordinate(latitude: dto.latitude, longitude: dto.longitude),
            currency: toDomain(dto.currency)
        )
    }

    private static func toDomain(_ dto: RegionDTO) -> CountryRegion {
        CountryRegion(englishName: dto.englishName, koreanName: dto.koreanName)
    }

    private static func toDomain(_ dto: CurrencyDTO) -> CurrencyInfo {
        CurrencyInfo(code: dto.code, symbol: dto.symbol)
    }

    // MARK: - Location / 주소

    public static func toDomain(_ dto: LocationAddressResponse) -> LocationAddress {
        LocationAddress(
            address: dto.address,
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
            let areaDescription = nonEmptyTrimmed(item.region) ?? nonEmptyTrimmed(item.address)
            return .place(
                PlaceSearchHit(
                    id: id,
                    title: item.name,
                    placeKind: nonEmptyTrimmed(item.category),
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
            Logger.shared.warning("Unknown location type: \(item.type)", category: .network)
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
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
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
