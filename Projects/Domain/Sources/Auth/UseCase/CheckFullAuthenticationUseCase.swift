public protocol CheckFullAuthenticationUseCase {
    func execute() async -> Bool
}

public final class DefaultCheckFullAuthenticationUseCase: CheckFullAuthenticationUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async -> Bool {
        await authRepo.isFullyAuthenticated()
    }
}
