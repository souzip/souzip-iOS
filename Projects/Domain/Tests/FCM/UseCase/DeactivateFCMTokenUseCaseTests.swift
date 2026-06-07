import XCTest
@testable import Domain

final class DeactivateFCMTokenUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockFCMRepository, DefaultDeactivateFCMTokenUseCase) {
        let mockRepository = MockFCMRepository()
        let sut = DefaultDeactivateFCMTokenUseCase(fcmRepository: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_토큰비활성화() async throws {
        let (mockRepository, sut) = makeSUT()

        try await sut.execute()

        XCTAssertEqual(mockRepository.deactivateCallCount, 1)
    }

    func test_비활성화실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.deactivateError = MockFCMError.failed

        do {
            try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockFCMError, .failed)
        }

        XCTAssertEqual(mockRepository.deactivateCallCount, 1)
    }
}
