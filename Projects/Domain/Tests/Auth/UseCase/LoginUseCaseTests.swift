import XCTest
@testable import Domain

final class LoginUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockAuthRepository, DefaultLoginUseCase) {
        let mockRepository = MockAuthRepository()
        let sut = DefaultLoginUseCase(authRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_프로바이더없음_게스트반환() async throws {
        let (mockRepository, sut) = makeSUT()

        let result = try await sut.execute(provider: nil)

        XCTAssertEqual(result, .guest)
        XCTAssertEqual(mockRepository.deleteAllTokensCallCount, 1)
        XCTAssertEqual(mockRepository.loginCallCount, 0)
    }

    func test_온보딩불필요_준비완료반환() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubLoginUser = LoginUser(
            userId: "user-1",
            nickname: "tester",
            needsOnboarding: false
        )

        let result = try await sut.execute(provider: .kakao)

        XCTAssertEqual(result, .ready)
        XCTAssertEqual(mockRepository.loginCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoginProvider, .kakao)
        XCTAssertEqual(mockRepository.deleteAllTokensCallCount, 0)
    }

    func test_온보딩필요_온보딩유도반환() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubLoginUser = LoginUser(
            userId: "user-1",
            nickname: "tester",
            needsOnboarding: true
        )

        let result = try await sut.execute(provider: .google)

        XCTAssertEqual(result, .shouldOnboarding)
        XCTAssertEqual(mockRepository.loginCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoginProvider, .google)
    }

    func test_로그인실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loginError = MockAuthError.failed

        do {
            _ = try await sut.execute(provider: .apple)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? MockAuthError, .failed)
        }

        XCTAssertEqual(mockRepository.loginCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoginProvider, .apple)
    }
}
