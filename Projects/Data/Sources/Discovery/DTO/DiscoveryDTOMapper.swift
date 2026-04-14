import Domain
import Foundation

public enum DiscoveryDTOMapper {
    public static func toDomain(_ dtos: [DiscoverySouvenirResponse]) -> [CatalogSouvenir] {
        dtos.map { toDomain($0) }
    }

    public static func toDomain(_ dto: DiscoverySouvenirResponse) -> CatalogSouvenir {
        CatalogSouvenir(
            id: dto.id,
            name: dto.name,
            category: SouvenirDTOMapper.mapToCategory(dto.category),
            countryCode: dto.countryCode,
            thumbnailUrl: dto.thumbnailUrl
        )
    }
}
