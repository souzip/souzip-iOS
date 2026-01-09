public struct CompleteOnboardingResponse: Decodable {
    public let userId: String
    public let nickname: String
    public let profileImageUrl: String
    public let categories: [CategoryDTO]
    public let agreements: AgreementsDTO

    public struct CategoryDTO: Decodable {
        public let name: String
        public let label: String
    }

    public struct AgreementsDTO: Decodable {
        public let ageVerified: Bool
        public let serviceTerms: Bool
        public let privacyRequired: Bool
        public let locationService: Bool
        public let marketingConsent: Bool
    }
}

public struct NicknameCheckResponse: Decodable {
    public let available: Bool
    public let message: String
}
