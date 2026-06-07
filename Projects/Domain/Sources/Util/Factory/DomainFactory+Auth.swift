public protocol DomainAuthFactory: AnyObject {
    func makeAutoLoginUseCase() -> AutoLoginUseCase
    func makeLoadRecentAuthProviderUseCase() -> LoadRecentAuthProviderUseCase
    func makeLoginUseCase() -> LoginUseCase
    func makeLogoutUseCase() -> LogoutUseCase
    func makeCheckFullAuthenticationUseCase() -> CheckFullAuthenticationUseCase
    func makeWithdrawUseCase() -> WithdrawUseCase

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
        return DefaultLogoutUseCase(
            authRepo: authRepo,
            deactivateFCMToken: makeDeactivateFCMTokenUseCase()
        )
    }

    func makeCheckFullAuthenticationUseCase() -> CheckFullAuthenticationUseCase {
        DefaultCheckFullAuthenticationUseCase(authRepo: factory.makeAuthRepository())
    }

    func makeWithdrawUseCase() -> WithdrawUseCase {
        DefaultWithdrawUseCase(authRepo: factory.makeAuthRepository())
    }

    func makeAuthRepository() -> AuthRepository {
        factory.makeAuthRepository()
    }
}
