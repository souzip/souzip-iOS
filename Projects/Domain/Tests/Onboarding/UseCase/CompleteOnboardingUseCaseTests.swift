import XCTest
@testable import Domain

final class CompleteOnboardingUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockOnboardingRepository, DefaultCompleteOnboardingUseCase) {
        let mockRepository = MockOnboardingRepository()
        let sut = DefaultCompleteOnboardingUseCase(onboardingRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상완료_로그인유저반환() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCompleteOnboardingUser = LoginUser(
            userId: "user-42",
            nickname: "수집러",
            needsOnboarding: false
        )

        let result = try await sut.execute()

        XCTAssertEqual(result.userId, "user-42")
        XCTAssertEqual(result.nickname, "수집러")
        XCTAssertFalse(result.needsOnboarding)
        XCTAssertEqual(mockRepository.completeOnboardingCallCount, 1)
    }

    func test_완료실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.completeOnboardingError = MockOnboardingError.failed

        do {
            _ = try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockOnboardingError, .failed)
        }

        XCTAssertEqual(mockRepository.completeOnboardingCallCount, 1)
    }
}
