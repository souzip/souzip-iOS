public protocol DomainAuthFactory: AnyObject {
    func makeAutoLoginUseCase() -> AutoLoginUseCase
    func makeLoadRecentAuthProviderUseCase() -> LoadRecentAuthProviderUseCase
    func makeLoginUseCase() -> LoginUseCase
    func makeLogoutUseCase() -> LogoutUseCase

    func makeAuthRepository() -> AuthRepository
}

public extension DefaultDomainFactory {
    func makeAutoLoginUseCase() -> AutoLoginUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultAutoLoginUseCase(authRepo: authRepo)
    }

    func makeLoadRecentAuthProviderUseCase() -> LoadRecentAuthProviderUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultLoadRecentAuthProviderUseCase(authRepo: authRepo)
    }

    func makeLoginUseCase() -> LoginUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultLoginUseCase(authRepo: authRepo)
    }

    func makeLogoutUseCase() -> LogoutUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultLogoutUseCase(authRepo: authRepo)
    }

    func makeAuthRepository() -> AuthRepository {
        factory.makeAuthRepository()
    }
}
