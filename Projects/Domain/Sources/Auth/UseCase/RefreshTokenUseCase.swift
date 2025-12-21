public protocol RefreshTokenUseCase {
    func execute() async throws -> LoginUser
}

public final class DefaultRefreshTokenUseCase: RefreshTokenUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async throws -> LoginUser {
        try await authRepo.refreshToken()
    }
}
