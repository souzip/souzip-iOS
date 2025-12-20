public protocol RefreshTokenUseCase {
    func execute() async throws -> LoginResult
}

public final class DefaultRefreshTokenUseCase: RefreshTokenUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async throws -> LoginResult {
        try await authRepo.refreshToken()
    }
}
