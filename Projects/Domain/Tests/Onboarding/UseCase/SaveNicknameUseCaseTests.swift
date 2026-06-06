import XCTest
@testable import Domain

final class SaveNicknameUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockOnboardingRepository, DefaultSaveNicknameUseCase) {
        let mockRepository = MockOnboardingRepository()
        let sut = DefaultSaveNicknameUseCase(onboardingRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_닉네임전달_저장호출() {
        let (mockRepository, sut) = makeSUT()

        sut.execute(nickname: "수집러")

        XCTAssertEqual(mockRepository.saveNicknameCallCount, 1)
        XCTAssertEqual(mockRepository.lastNickname, "수집러")
    }
}
