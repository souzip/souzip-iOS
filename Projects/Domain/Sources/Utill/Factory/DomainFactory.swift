public protocol DomainFactory: AnyObject {
    func makeCheckLoginStatusUseCase() -> AutoLoginUseCase
    func makeRefreshTokenUseCase() -> RefreshTokenUseCase
    func makeLoginUseCase() -> LoginUseCase
    func makeLogoutUseCase() -> LogoutUseCase
}

public final class DefaultDomainFactory: DomainFactory {
    private let factory: DataFactory

    public init(factory: DataFactory) {
        self.factory = factory
    }

    public func makeCheckLoginStatusUseCase() -> AutoLoginUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultAutoLoginUseCase(authRepo: authRepo)
    }

    public func makeRefreshTokenUseCase() -> RefreshTokenUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultRefreshTokenUseCase(authRepo: authRepo)
    }

    public func makeLoginUseCase() -> LoginUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultLoginUseCase(authRepo: authRepo)
    }

    public func makeLogoutUseCase() -> LogoutUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultLogoutUseCase(authRepo: authRepo)
    }
}
