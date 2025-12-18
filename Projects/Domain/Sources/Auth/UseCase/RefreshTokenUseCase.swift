public protocol RefreshTokenUseCase {
    func execute() async throws -> LoginResult
}

public final class DefaultRefreshTokenUseCase: RefreshTokenUseCase {
    private let repo: AuthRepository

    public init(repo: AuthRepository) {
        self.repo = repo
    }

    public func execute() async throws -> LoginResult {
        try await repo.refreshToken()
    }
}
