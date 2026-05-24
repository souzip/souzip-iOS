import XCTest
@testable import Domain

final class AutoLoginUseCaseTests: XCTestCase {
    func test_미로그인_로그인유도반환() async {
        let mock = MockAuthRepository()
        mock.checkLoginStatusResult = false
        let sut = DefaultAutoLoginUseCase(authRepo: mock)

        let result = await sut.execute()

        XCTAssertEqual(result, .shouldLogin)
    }

    func test_토큰갱신실패_로그인유도반환() async {
        let mock = MockAuthRepository()
        mock.checkLoginStatusResult = true
        mock.shouldRefreshTokenThrow = true
        let sut = DefaultAutoLoginUseCase(authRepo: mock)

        let result = await sut.execute()

        XCTAssertEqual(result, .shouldLogin)
    }

    func test_온보딩필요_온보딩유도반환() async {
        let mock = MockAuthRepository()
        mock.checkLoginStatusResult = true
        mock.refreshTokenResult = DomainTestFixtures.loginUserNeedsOnboarding
        let sut = DefaultAutoLoginUseCase(authRepo: mock)

        let result = await sut.execute()

        XCTAssertEqual(result, .shouldOnboarding)
    }

    func test_로그인완료_준비완료반환() async {
        let mock = MockAuthRepository()
        mock.checkLoginStatusResult = true
        mock.refreshTokenResult = DomainTestFixtures.loginUser
        let sut = DefaultAutoLoginUseCase(authRepo: mock)

        let result = await sut.execute()

        XCTAssertEqual(result, .ready)
    }
}
