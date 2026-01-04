import Domain
import Keychain
import Networking

public final class DefaultAuthRepository: AuthRepository {
    private let authRemote: AuthRemoteDataSource
    private let authLocal: AuthLocalDataSource
    private let userLocal: UserLocalDataSource

    public init(
        authRemote: AuthRemoteDataSource,
        authLocal: AuthLocalDataSource,
        userLocal: UserLocalDataSource
    ) {
        self.authRemote = authRemote
        self.authLocal = authLocal
        self.userLocal = userLocal
    }

    public func login(provider: AuthProvider) async throws -> LoginUser {
        do {
            let platform = mapToPlatform(provider)
            let dto = try await authRemote.login(platform: platform)

            try await authLocal.saveAccessToken(dto.accessToken)
            try await authLocal.saveRefreshToken(dto.refreshToken)

            authLocal.saveOAuthPlatform(platform)

            userLocal.saveUserId(dto.user.userId)
            userLocal.saveUserNickname(dto.user.nickname)

            return AuthDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func logout() async throws {
        do {
            try await authRemote.logout()
            await authLocal.deleteAllTokens()
            userLocal.deleteUser()
        } catch {
            await authLocal.deleteAllTokens()
            userLocal.deleteUser()
            throw mapToDomainError(error)
        }
    }

    public func withdraw() async throws {
        do {
            try await authRemote.withdraw()
            await authLocal.deleteAllTokens()
            userLocal.deleteUser()
        } catch {
            await authLocal.deleteAllTokens()
            userLocal.deleteUser()
            throw mapToDomainError(error)
        }
    }

    public func checkLoginStatus() async -> Bool {
        do {
            _ = try await authLocal.getAccessToken()
            _ = try await authLocal.getRefreshToken()
            return true
        } catch {
            return false
        }
    }

    public func refreshToken() async throws -> LoginUser {
        do {
            let refreshToken = try await authLocal.getRefreshToken()
            let dto = try await authRemote.refresh(refreshToken: refreshToken)

            try await authLocal.saveAccessToken(dto.accessToken)
            try await authLocal.saveRefreshToken(dto.refreshToken)

            guard let userDTO = userLocal.getUser() else {
                throw AuthError.invalidUser
            }

            return UserDTOMapper.toDomain(userDTO)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func loadRecentLoginProvider() -> AuthProvider? {
        let platform = authLocal.getOAuthPlatform()
        guard let platform else { return nil }
        return mapToProvider(platform)
    }
}

// MARK: - Mapper

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
