import XCTest
@testable import Domain

final class SaveProfileImageColorUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockOnboardingRepository, DefaultSaveProfileImageColorUseCase) {
        let mockRepository = MockOnboardingRepository()
        let sut = DefaultSaveProfileImageColorUseCase(onboardingRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_프로필색상전달_저장호출() {
        let (mockRepository, sut) = makeSUT()

        sut.execute(color: .purple)

        XCTAssertEqual(mockRepository.saveProfileImageColorCallCount, 1)
        XCTAssertEqual(mockRepository.lastProfileImageColor, .purple)
    }
}
