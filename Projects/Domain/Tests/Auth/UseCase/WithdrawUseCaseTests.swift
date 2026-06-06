import XCTest
@testable import Domain

final class WithdrawUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockAuthRepository, DefaultWithdrawUseCase) {
        let mockRepository = MockAuthRepository()
        let sut = DefaultWithdrawUseCase(authRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_탈퇴실행() async throws {
        let (mockRepository, sut) = makeSUT()

        try await sut.execute()

        XCTAssertEqual(mockRepository.withdrawCallCount, 1)
    }

    func test_탈퇴실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.withdrawError = MockAuthError.failed

        do {
            try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockAuthError, .failed)
        }

        XCTAssertEqual(mockRepository.withdrawCallCount, 1)
    }
}
