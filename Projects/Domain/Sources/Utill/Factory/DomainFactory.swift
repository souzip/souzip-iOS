public protocol DomainFactory: AnyObject {
    func makeCheckLoginStatusUseCase() -> CheckLoginStatusUseCase
    func makeRefreshTokenUseCase() -> RefreshTokenUseCase
    func makeLoginUseCase() -> LoginUseCase
    func makeLogoutUseCase() -> LogoutUseCase
}

public final class DefaultDomainFactory: DomainFactory {
    private let factory: DataFactory

    public init(factory: DataFactory) {
        self.factory = factory
    }

    public func makeCheckLoginStatusUseCase() -> CheckLoginStatusUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultCheckLoginStatusUseCase(repo: authRepo)
    }

    public func makeRefreshTokenUseCase() -> RefreshTokenUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultRefreshTokenUseCase(repo: authRepo)
    }

    public func makeLoginUseCase() -> LoginUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultLoginUseCase(repo: authRepo)
    }

    public func makeLogoutUseCase() -> LogoutUseCase {
        let authRepo = factory.makeAuthRepository()
        return DefaultLogoutUseCase(repo: authRepo)
    }
}
