import Domain
import Foundation

public enum SouvenirDTOMapper {
    // MARK: - Detail Response to Domain

    public static func toDomain(_ dto: SouvenirDetailResponse) -> SouvenirDetail {
        SouvenirDetail(
            id: dto.id,
            name: dto.name,
            localPrice: dto.localPrice,
            currencySymbol: dto.currencySymbol,
            krwPrice: dto.krwPrice,
            description: dto.description,
            address: dto.address,
            locationDetail: dto.locationDetail,
            coordinate: Coordinate(latitude: dto.latitude, longitude: dto.longitude),
            category: mapToCategory(dto.category),
            purpose: mapToPurpose(dto.purpose),
            countryCode: dto.countryCode,
            isOwned: dto.isOwned,
            owner: SouvenirOwner(
                nickname: dto.userNickname,
                profileImageUrl: dto.userProfileImageUrl
            ),
            files: dto.files.map { toDomain($0) }
        )
    }

    public static func toDomain(_ dto: SouvenirFileResponse) -> SouvenirFile {
        SouvenirFile(
            id: dto.id,
            url: dto.url,
            originalName: dto.originalName,
            displayOrder: dto.displayOrder
        )
    }

    // MARK: - Nearby Response to Domain

    public static func toDomain(_ dto: NearbySouvenirsResponse) -> [SouvenirListItem] {
        dto.souvenirs.map { toDomain($0) }
    }

    public static func toDomain(_ dto: NearbySouvenirResponse) -> SouvenirListItem {
        SouvenirListItem(
            id: dto.id,
            name: dto.name,
            category: mapToCategory(dto.category),
            purpose: mapToPurpose(dto.purpose),
            localPrice: dto.localPrice,
            krwPrice: dto.krwPrice,
            currencySymbol: dto.currencySymbol,
            thumbnail: dto.thumbnail,
            coordinate: Coordinate(latitude: dto.latitude, longitude: dto.longitude),
            address: dto.address
        )
    }

    // MARK: - Domain to Request

    public static func toRequest(_ input: SouvenirInput) -> SouvenirRequest {
        SouvenirRequest(
            name: input.name,
            localPrice: input.localPrice,
            currencySymbol: input.currencySymbol,
            krwPrice: input.krwPrice,
            description: input.description,
            address: input.address,
            locationDetail: input.locationDetail,
            latitude: input.coordinate.latitude,
            longitude: input.coordinate.longitude,
            category: toDTO(input.category),
            purpose: toDTO(input.purpose),
            countryCode: input.countryCode
        )
    }
}

// MARK: - Private Mapper (String ↔ Enum)

extension SouvenirDTOMapper {
    // API String → Domain Enum
    static func mapToCategory(_ category: String) -> SouvenirCategory {
        switch category {
        case "FOOD_SNACK": .snack
        case "BEAUTY_HEALTH": .healthBeauty
        case "FASHION_ACCESSORY": .fashion
        case "CULTURE_TRADITION": .culture
        case "TOY_KIDS": .toy
        case "SOUVENIR_BASIC": .classic
        case "HOME_LIFESTYLE": .lifestyle
        case "STATIONERY_ART": .art
        case "TRAVEL_PRACTICAL": .travel
        case "TECH_GADGET": .tech
        default: .classic
        }
    }

    static func mapToPurpose(_ purpose: String) -> SouvenirPurpose {
        switch purpose {
        case "GIFT": .gift
        case "PERSONAL": .personal
        default: .gift
        }
    }

    // Domain Enum → API String
    static func toDTO(_ category: SouvenirCategory) -> String {
        switch category {
        case .snack: "FOOD_SNACK"
        case .healthBeauty: "BEAUTY_HEALTH"
        case .fashion: "FASHION_ACCESSORY"
        case .culture: "CULTURE_TRADITION"
        case .toy: "TOY_KIDS"
        case .classic: "SOUVENIR_BASIC"
        case .lifestyle: "HOME_LIFESTYLE"
        case .art: "STATIONERY_ART"
        case .travel: "TRAVEL_PRACTICAL"
        case .tech: "TECH_GADGET"
        }
    }

    static func toDTO(_ purpose: SouvenirPurpose) -> String {
        switch purpose {
        case .gift: "GIFT"
        case .personal: "PERSONAL"
        }
    }
}
