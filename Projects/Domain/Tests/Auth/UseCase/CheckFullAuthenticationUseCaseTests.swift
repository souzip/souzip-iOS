import XCTest
@testable import Domain

final class CheckFullAuthenticationUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockAuthRepository, DefaultCheckFullAuthenticationUseCase) {
        let mockRepository = MockAuthRepository()
        let sut = DefaultCheckFullAuthenticationUseCase(authRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_완전인증상태_true반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubIsFullyAuthenticated = true

        let result = await sut.execute()

        XCTAssertTrue(result)
        XCTAssertEqual(mockRepository.isFullyAuthenticatedCallCount, 1)
    }

    func test_미인증상태_false반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubIsFullyAuthenticated = false

        let result = await sut.execute()

        XCTAssertFalse(result)
        XCTAssertEqual(mockRepository.isFullyAuthenticatedCallCount, 1)
    }
}
