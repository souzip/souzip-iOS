public protocol LoginUseCase {
    func execute(provider: AuthProvider) async throws -> LoginResult
}

public final class DefaultLoginUseCase: LoginUseCase {
    private let repo: AuthRepository

    public init(repo: AuthRepository) {
        self.repo = repo
    }

    public func execute(provider: AuthProvider) async throws -> LoginResult {
        try await repo.login(provider: provider)
    }
}
