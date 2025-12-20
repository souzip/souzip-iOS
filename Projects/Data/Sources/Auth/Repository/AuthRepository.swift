import Domain
import Keychain
import Networking
import UserDefaults

public final class DefaultAuthRepository: AuthRepository {
    private let authremote: AuthRemoteDataSource
    private let authlocal: AuthLocalDataSource
    private let userLocal: UserLocalDataSource

    public init(
        authRemote: AuthRemoteDataSource,
        authLocal: AuthLocalDataSource,
        userLocal: UserLocalDataSource
    ) {
        authremote = authRemote
        authlocal = authLocal
        self.userLocal = userLocal
    }

    public func login(provider: AuthProvider) async throws -> LoginResult {
        do {
            let platform = mapToPlatform(provider)
            let dto = try await authremote.login(platform: platform)

            try await authlocal.saveAccessToken(dto.accessToken)
            try await authlocal.saveRefreshToken(dto.refreshToken)
            authlocal.saveOAuthPlatform(platform)

            let user = LoginUserResponse(
                userId: dto.user.userId,
                nickname: dto.user.nickname
            )
            userLocal.saveUser(user)

            return mapToDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func logout() async throws {
        do {
            await authlocal.deleteAllTokens()
            userLocal.deleteUser()
            try await authremote.logout()
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func withdraw() async throws {
        do {
            await authlocal.deleteAllTokens()
            userLocal.deleteUser()
            try await authremote.withdraw()
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func checkLoginStatus() async -> Bool {
        do {
            _ = try await authlocal.getAccessToken()
            _ = try await authlocal.getRefreshToken()
            return true
        } catch {
            return false
        }
    }

    public func refreshToken() async throws -> LoginResult {
        do {
            let refreshToken = try await authlocal.getRefreshToken()
            let dto = try await authremote.refresh(refreshToken: refreshToken)

            try await authlocal.saveAccessToken(dto.accessToken)
            try await authlocal.saveRefreshToken(dto.refreshToken)

            guard let user = userLocal.getUser() else {
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

    public func loadRecentLoginProvider() -> AuthProvider? {
        let platform = authlocal.getOAuthPlatform()
        guard let platform else { return nil }
        return mapToProvider(platform)
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

    func mapToProvider(_ platform: OAuthPlatform) -> AuthProvider {
        switch platform {
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
