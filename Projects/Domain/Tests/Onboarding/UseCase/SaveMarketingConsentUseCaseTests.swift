import XCTest
@testable import Domain

final class SaveMarketingConsentUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockOnboardingRepository, DefaultSaveMarketingConsentUseCase) {
        let mockRepository = MockOnboardingRepository()
        let sut = DefaultSaveMarketingConsentUseCase(onboardingRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_마케팅동의_저장호출() {
        let (mockRepository, sut) = makeSUT()

        sut.execute(isAgreed: true)

        XCTAssertEqual(mockRepository.saveMarketingConsentCallCount, 1)
        XCTAssertEqual(mockRepository.lastMarketingConsent, true)
    }

    func test_마케팅비동의_저장호출() {
        let (mockRepository, sut) = makeSUT()

        sut.execute(isAgreed: false)

        XCTAssertEqual(mockRepository.saveMarketingConsentCallCount, 1)
        XCTAssertEqual(mockRepository.lastMarketingConsent, false)
    }
}
