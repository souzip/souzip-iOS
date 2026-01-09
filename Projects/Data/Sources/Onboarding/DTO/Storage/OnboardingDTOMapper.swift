import Domain

public enum OnboardingDTOMapper {
    // MARK: - Response to Domain

    public static func toDomain(_ dto: CompleteOnboardingResponse) -> LoginUser {
        LoginUser(
            userId: dto.userId,
            nickname: dto.nickname,
            needsOnboarding: false
        )
    }

    // MARK: - Domain to DTO

    public static func toDTO(_ color: ProfileImageType) -> String {
        switch color {
        case .red: "red"
        case .yellow: "yellow"
        case .purple: "purple"
        case .blue: "blue"
        }
    }

    public static func toDTO(_ category: SouvenirCategory) -> String {
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
}
