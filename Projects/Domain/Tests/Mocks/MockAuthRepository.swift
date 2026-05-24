import XCTest
@testable import Domain

final class MockAuthRepository: AuthRepository {
    var checkLoginStatusResult = false
    var refreshTokenResult: LoginUser = DomainTestFixtures.loginUser
    var shouldRefreshTokenThrow = false
    var loginResult: LoginUser = DomainTestFixtures.loginUser
    var isFullyAuthenticatedResult = false
    var loadRecentLoginProviderResult: AuthProvider?

    private(set) var logoutCallCount = 0
    private(set) var withdrawCallCount = 0
    private(set) var deleteAllTokensCallCount = 0
    private(set) var loginCallCount = 0
    private(set) var lastLoginProvider: AuthProvider?

    func login(provider: AuthProvider) async throws -> LoginUser {
        loginCallCount += 1
        lastLoginProvider = provider
        return loginResult
    }

    func logout() async throws {
        logoutCallCount += 1
    }

    func withdraw() async throws {
        withdrawCallCount += 1
    }

    func checkLoginStatus() async -> Bool {
        checkLoginStatusResult
    }

    func refreshToken() async throws -> LoginUser {
        if shouldRefreshTokenThrow {
            throw NSError(domain: "MockAuthRepository", code: 1)
        }
        return refreshTokenResult
    }

    func loadRecentLoginProvider() -> AuthProvider? {
        loadRecentLoginProviderResult
    }

    func deleteAllTokens() async {
        deleteAllTokensCallCount += 1
    }

    func isFullyAuthenticated() async -> Bool {
        isFullyAuthenticatedResult
    }
}
