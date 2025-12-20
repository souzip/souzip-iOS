import Domain
import Keychain
import Networking

public final class DefaultAuthRepository: AuthRepository {
    private let remote: AuthRemoteDataSource
    private let local: AuthLocalDataSource
    private let userLocal: UserLocalDataSource

    public init(
        remote: AuthRemoteDataSource,
        local: AuthLocalDataSource,
        userLocal: UserLocalDataSource
    ) {
        self.remote = remote
        self.local = local
        self.userLocal = userLocal
    }

    public func login(provider: AuthProvider) async throws -> LoginResult {
        do {
            let platform = mapToPlatform(provider)
            let dto = try await remote.login(platform: platform)

            try await local.saveAccessToken(dto.accessToken)
            try await local.saveRefreshToken(dto.refreshToken)

            let user = LoginUserResponse(
                userId: dto.user.userId,
                nickname: dto.user.nickname
            )
            try userLocal.saveUser(user)

            return mapToDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func logout() async throws {
        do {
            try await remote.logout()
            try await local.deleteAllTokens()
            userLocal.deleteUser()
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func withdraw() async throws {
        do {
            try await remote.withdraw()
            try await local.deleteAllTokens()
            userLocal.deleteUser()
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func checkLoginStatus() async -> Bool {
        do {
            _ = try await local.getAccessToken()
            _ = try await local.getRefreshToken()
            return true
        } catch {
            return false
        }
    }

    public func refreshToken() async throws -> LoginResult {
        do {
            let refreshToken = try await local.getRefreshToken()
            let dto = try await remote.refresh(refreshToken: refreshToken)

            try await local.saveAccessToken(dto.accessToken)
            try await local.saveRefreshToken(dto.refreshToken)

            guard let user = try userLocal.getUser() else {
                throw AuthError.invalidUser
            }

            return LoginResult(
                nickname: user.nickname,
                needsOnboarding: false
            )
        } catch {
            throw mapToDomainError(error)
        }
    }
}

private extension DefaultAuthRepository {
    func mapToPlatform(_ provider: AuthProvider) -> OAuthPlatform {
        switch provider {
        case .kakao: .kakao
        case .google: .google
        case .apple: .apple
        }
    }

    func mapToDomain(_ dto: LoginResponse) -> LoginResult {
        LoginResult(
            nickname: dto.user.nickname,
            needsOnboarding: dto.needsOnboarding
        )
    }

    func mapToDomainError(_ error: Error) -> AuthError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                return .expired

            case .noData, .invalidURL, .unknown,
                 .serverError,
                 .encodingError, .decodingError:
                return .loginFailed
            }
        }

        if let keychainError = error as? KeychainError {
            switch keychainError {
            case .itemNotFound:
                return .expired

            case .decodingFailed:
                return .invalidToken

            case .encodingFailed,
                 .saveFailed,
                 .loadFailed,
                 .deleteFailed:
                return .tokenStorageFailed
            }
        }

        if let oauthError = error as? OAuthServiceError {
            switch oauthError {
            case .cancelled:
                return .loginCancelled

            case .notSupported:
                return .unsupportedProvider

            case .sdkError, .unknown:
                return .loginFailed
            }
        }

        return AuthError.loginFailed
    }
}
