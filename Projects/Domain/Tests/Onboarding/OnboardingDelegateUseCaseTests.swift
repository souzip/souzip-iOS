import XCTest
@testable import Domain

final class OnboardingDelegateUseCaseTests: XCTestCase {
    func test_온보딩완료_사용자반환() async throws {
        let mock = MockOnboardingRepository()
        mock.completeOnboardingResult = DomainTestFixtures.loginUser
        let sut = DefaultCompleteOnboardingUseCase(onboardingRepo: mock)

        let result = try await sut.execute()

        XCTAssertEqual(result.userId, "user-1")
        XCTAssertEqual(mock.completeOnboardingCallCount, 1)
    }

    func test_마케팅동의저장_값전달() {
        let mock = MockOnboardingRepository()
        let sut = DefaultSaveMarketingConsentUseCase(onboardingRepo: mock)

        sut.execute(isAgreed: true)

        XCTAssertEqual(mock.saveMarketingConsentCallCount, 1)
        XCTAssertEqual(mock.lastMarketingConsent, true)
    }

    func test_닉네임저장_값전달() {
        let mock = MockOnboardingRepository()
        let sut = DefaultSaveNicknameUseCase(onboardingRepo: mock)

        sut.execute(nickname: "수집러")

        XCTAssertEqual(mock.saveNicknameCallCount, 1)
        XCTAssertEqual(mock.lastSavedNickname, "수집러")
    }

    func test_프로필색저장_값전달() {
        let mock = MockOnboardingRepository()
        let sut = DefaultSaveProfileImageColorUseCase(onboardingRepo: mock)

        sut.execute(color: .blue)

        XCTAssertEqual(mock.saveProfileImageColorCallCount, 1)
        XCTAssertEqual(mock.lastProfileImageColor, .blue)
    }

    func test_카테고리저장_목록전달() {
        let mock = MockOnboardingRepository()
        let sut = DefaultSaveCategoriesUseCase(onboardingRepo: mock)

        sut.execute(categories: [.snack, .culture])

        XCTAssertEqual(mock.saveCategoriesCallCount, 1)
        XCTAssertEqual(mock.lastSavedCategories, [.snack, .culture])
    }
}
