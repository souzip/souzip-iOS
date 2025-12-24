public protocol DataFactory: AnyObject {
    func makeAuthRepository() -> AuthRepository
    func makeOnboardingRepository() -> OnboardingRepository
}
