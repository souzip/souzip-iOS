public protocol LoginUseCase {
    func execute(provider: AuthProvider) async throws -> LoginResult
}

public final class DefaultLoginUseCase: LoginUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute(provider: AuthProvider) async throws -> LoginResult {
        let user = try await authRepo.login(provider: provider)

        if user.needsOnboarding {
            return .shouldOnboarding
        }

        return .ready
    }
}
