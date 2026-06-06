import XCTest
@testable import Domain

final class LoadRecentAuthProviderUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockAuthRepository, DefaultLoadRecentAuthProviderUseCase) {
        let mockRepository = MockAuthRepository()
        let sut = DefaultLoadRecentAuthProviderUseCase(authRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_최근프로바이더있음_프로바이더반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubLoadRecentLoginProvider = .kakao

        let result = await sut.execute()

        XCTAssertEqual(result, .kakao)
        XCTAssertEqual(mockRepository.loadRecentLoginProviderCallCount, 1)
    }

    func test_최근프로바이더없음_nil반환() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubLoadRecentLoginProvider = nil

        let result = await sut.execute()

        XCTAssertNil(result)
        XCTAssertEqual(mockRepository.loadRecentLoginProviderCallCount, 1)
    }
}
