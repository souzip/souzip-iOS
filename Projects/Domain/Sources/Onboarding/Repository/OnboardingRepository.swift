public protocol OnboardingRepository {
    func saveMarketingConsent(_ isAgreed: Bool)
    func saveNickname(_ nickname: String)
    func saveProfileImageColor(_ color: ProfileImageType)
    func saveCategories(_ categories: [SouvenirCategory])

    func completeOnboarding() async throws -> LoginUser
    func checkNickname(_ nickname: String) async throws -> Bool
}
