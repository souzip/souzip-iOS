import XCTest
@testable import Domain

final class LoginUseCaseTests: XCTestCase {
    func test_프로바이더없음_게스트반환() async throws {
        let mock = MockAuthRepository()
        let sut = DefaultLoginUseCase(authRepo: mock)

        let result = try await sut.execute(provider: nil)

        XCTAssertEqual(result, .guest)
        XCTAssertEqual(mock.deleteAllTokensCallCount, 1)
        XCTAssertEqual(mock.loginCallCount, 0)
    }

    func test_온보딩필요_온보딩유도반환() async throws {
        let mock = MockAuthRepository()
        mock.loginResult = DomainTestFixtures.loginUserNeedsOnboarding
        let sut = DefaultLoginUseCase(authRepo: mock)

        let result = try await sut.execute(provider: .kakao)

        XCTAssertEqual(result, .shouldOnboarding)
        XCTAssertEqual(mock.lastLoginProvider, .kakao)
    }

    func test_로그인성공_준비완료반환() async throws {
        let mock = MockAuthRepository()
        mock.loginResult = DomainTestFixtures.loginUser
        let sut = DefaultLoginUseCase(authRepo: mock)

        let result = try await sut.execute(provider: .apple)

        XCTAssertEqual(result, .ready)
        XCTAssertEqual(mock.lastLoginProvider, .apple)
    }
}
