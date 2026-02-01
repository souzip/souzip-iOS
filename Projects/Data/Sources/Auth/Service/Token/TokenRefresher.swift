import Networking

public final class DefaultTokenRefresher: TokenRefresher {
    private let authLocal: AuthLocalDataSource
    private let authRemote: AuthRemoteDataSource
    private let userLocal: UserLocalDataSource

    private let synchronizer = RefreshSynchronizer()

    public init(
        authLocal: AuthLocalDataSource,
        authRemote: AuthRemoteDataSource,
        userLocal: UserLocalDataSource
    ) {
        self.authLocal = authLocal
        self.authRemote = authRemote
        self.userLocal = userLocal
    }

    public func getAccessToken() async throws -> String? {
        try? await authLocal.getAccessToken()
    }

    public func refreshToken() async throws {
        try await synchronizer.execute { [weak self] in
            guard let self else { return }

            let refreshToken = try await authLocal.getRefreshToken()
            let dto = try await authRemote.refresh(refreshToken: refreshToken)

            try await authLocal.saveAccessToken(dto.accessToken)
            try await authLocal.saveRefreshToken(dto.refreshToken)
        }
    }

    public func clearTokens() async throws {
        await authLocal.deleteAllTokens()
        userLocal.deleteUser()
    }
}
