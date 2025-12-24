public struct OnboardingCategoryDTO: Codable {
    public let value: String

    public init(value: String) {
        self.value = value
    }
}

public struct OnboardingTemporaryData {
    public let marketingConsent: Bool
    public let nickname: String
    public let profileImageColor: String
    public let categories: [OnboardingCategoryDTO]

    public init(
        marketingConsent: Bool,
        nickname: String,
        profileImageColor: String,
        categories: [OnboardingCategoryDTO]
    ) {
        self.marketingConsent = marketingConsent
        self.nickname = nickname
        self.profileImageColor = profileImageColor
        self.categories = categories
    }
}
