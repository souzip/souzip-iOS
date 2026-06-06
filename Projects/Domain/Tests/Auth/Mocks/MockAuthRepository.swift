import Foundation
@testable import Domain

final class MockAuthRepository: AuthRepository {
    var stubLoginUser = LoginUser(userId: "user-1", nickname: "tester", needsOnboarding: false)
    var stubCheckLoginStatus = false
    var stubRefreshTokenResult: Result<LoginUser, Error>?
    var stubLoadRecentLoginProvider: AuthProvider?
    var stubIsFullyAuthenticated = false

    var loginError: Error?
    var logoutError: Error?
    var withdrawError: Error?

    private(set) var loginCallCount = 0
    private(set) var lastLoginProvider: AuthProvider?
    private(set) var logoutCallCount = 0
    private(set) var withdrawCallCount = 0
    private(set) var checkLoginStatusCallCount = 0
    private(set) var refreshTokenCallCount = 0
    private(set) var loadRecentLoginProviderCallCount = 0
    private(set) var deleteAllTokensCallCount = 0
    private(set) var isFullyAuthenticatedCallCount = 0

    func login(provider: AuthProvider) async throws -> LoginUser {
        loginCallCount += 1
        lastLoginProvider = provider

        if let loginError {
            throw loginError
        }

        return stubLoginUser
    }

    func logout() async throws {
        logoutCallCount += 1

        if let logoutError {
            throw logoutError
        }
    }

    func withdraw() async throws {
        withdrawCallCount += 1

        if let withdrawError {
            throw withdrawError
        }
    }

    func checkLoginStatus() async -> Bool {
        checkLoginStatusCallCount += 1
        return stubCheckLoginStatus
    }

    func refreshToken() async throws -> LoginUser {
        refreshTokenCallCount += 1

        if let stubRefreshTokenResult {
            switch stubRefreshTokenResult {
            case let .success(user):
                return user
            case let .failure(error):
                throw error
            }
        }

        return stubLoginUser
    }

    func loadRecentLoginProvider() -> AuthProvider? {
        loadRecentLoginProviderCallCount += 1
        return stubLoadRecentLoginProvider
    }

    func deleteAllTokens() async {
        deleteAllTokensCallCount += 1
    }

    func isFullyAuthenticated() async -> Bool {
        isFullyAuthenticatedCallCount += 1
        return stubIsFullyAuthenticated
    }
}

enum MockAuthError: Error {
    case failed
}
