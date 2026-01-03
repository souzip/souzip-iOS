public protocol DataFactory: AnyObject {
    func makeAuthRepository() -> AuthRepository
    func makeOnboardingRepository() -> OnboardingRepository
    func makeCountryRepository() -> CountryRepository
    func makeSouvenirRepository() -> SouvenirRepository
    func makeDiscoveryRepository() -> DiscoveryRepository
    func makeUserRepository() -> UserRepository
}
