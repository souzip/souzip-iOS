import XCTest
@testable import Domain

final class AuthDelegateUseCaseTests: XCTestCase {
    func test_완전인증조회_결과전달() async {
        let mock = MockAuthRepository()
        mock.isFullyAuthenticatedResult = true
        let sut = DefaultCheckFullAuthenticationUseCase(authRepo: mock)

        let result = await sut.execute()

        XCTAssertTrue(result)
    }

    func test_로그아웃_한번위임() async throws {
        let mock = MockAuthRepository()
        let sut = DefaultLogoutUseCase(authRepo: mock)

        try await sut.execute()

        XCTAssertEqual(mock.logoutCallCount, 1)
    }

    func test_회원탈퇴_한번위임() async throws {
        let mock = MockAuthRepository()
        let sut = DefaultWithdrawUseCase(authRepo: mock)

        try await sut.execute()

        XCTAssertEqual(mock.withdrawCallCount, 1)
    }

    func test_최근로그인프로바이더_결과전달() async {
        let mock = MockAuthRepository()
        mock.loadRecentLoginProviderResult = .google
        let sut = DefaultLoadRecentAuthProviderUseCase(authRepo: mock)

        let result = await sut.execute()

        XCTAssertEqual(result, .google)
    }
}
