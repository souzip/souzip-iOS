import XCTest
@testable import Domain

final class AutoLoginUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockAuthRepository, DefaultAutoLoginUseCase) {
        let mockRepository = MockAuthRepository()
        let sut = DefaultAutoLoginUseCase(authRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_비로그인상태_로그인유도반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCheckLoginStatus = false

        let result = await sut.execute()

        XCTAssertEqual(result, .shouldLogin)
        XCTAssertEqual(mockRepository.checkLoginStatusCallCount, 1)
        XCTAssertEqual(mockRepository.refreshTokenCallCount, 0)
    }

    func test_토큰갱신실패_로그인유도반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCheckLoginStatus = true
        mockRepository.stubRefreshTokenResult = .failure(MockAuthError.failed)

        let result = await sut.execute()

        XCTAssertEqual(result, .shouldLogin)
        XCTAssertEqual(mockRepository.checkLoginStatusCallCount, 1)
        XCTAssertEqual(mockRepository.refreshTokenCallCount, 1)
    }

    func test_온보딩불필요_준비완료반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCheckLoginStatus = true
        mockRepository.stubRefreshTokenResult = .success(
            LoginUser(userId: "user-1", nickname: "tester", needsOnboarding: false)
        )

        let result = await sut.execute()

        XCTAssertEqual(result, .ready)
        XCTAssertEqual(mockRepository.refreshTokenCallCount, 1)
    }

    func test_온보딩필요_온보딩유도반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCheckLoginStatus = true
        mockRepository.stubRefreshTokenResult = .success(
            LoginUser(userId: "user-1", nickname: "tester", needsOnboarding: true)
        )

        let result = await sut.execute()

        XCTAssertEqual(result, .shouldOnboarding)
        XCTAssertEqual(mockRepository.refreshTokenCallCount, 1)
    }
}
