public protocol LoadRecentAuthProviderUseCase {
    func execute() async -> AuthProvider?
}

public final class DefaultLoadRecentAuthProviderUseCase: LoadRecentAuthProviderUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async -> AuthProvider? {
        authRepo.loadRecentLoginProvider()
    }
}
