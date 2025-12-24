public struct CompleteOnboardingRequest: Encodable {
    let ageVerified: Bool
    let serviceTerms: Bool
    let privacyRequired: Bool
    let locationService: Bool
    let marketingConsent: Bool
    let nickname: String
    let profileImageColor: String
    let categories: [String]

    public init(
        ageVerified: Bool,
        serviceTerms: Bool,
        privacyRequired: Bool,
        locationService: Bool,
        marketingConsent: Bool,
        nickname: String,
        profileImageColor: String,
        categories: [String]
    ) {
        self.ageVerified = ageVerified
        self.serviceTerms = serviceTerms
        self.privacyRequired = privacyRequired
        self.locationService = locationService
        self.marketingConsent = marketingConsent
        self.nickname = nickname
        self.profileImageColor = profileImageColor
        self.categories = categories
    }
}

public struct CheckNicknameRequest: Encodable {
    let nickname: String

    public init(nickname: String) {
        self.nickname = nickname
    }
}
