import XCTest
@testable import Domain

final class LogoutUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockAuthRepository, DefaultLogoutUseCase) {
        let mockRepository = MockAuthRepository()
        let sut = DefaultLogoutUseCase(authRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_로그아웃실행() async throws {
        let (mockRepository, sut) = makeSUT()

        try await sut.execute()

        XCTAssertEqual(mockRepository.logoutCallCount, 1)
    }

    func test_로그아웃실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.logoutError = MockAuthError.failed

        do {
            try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockAuthError, .failed)
        }

        XCTAssertEqual(mockRepository.logoutCallCount, 1)
    }
}
