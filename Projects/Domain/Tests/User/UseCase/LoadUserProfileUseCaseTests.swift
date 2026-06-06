import XCTest
@testable import Domain

final class LoadUserProfileUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockUserRepository, DefaultLoadUserProfileUseCase) {
        let mockRepository = MockUserRepository()
        let sut = DefaultLoadUserProfileUseCase(userRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_프로필조회성공_프로필반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expectedProfile = UserProfile(
            userId: "user-42",
            nickname: "collector",
            email: "collector@example.com",
            profileImageUrl: "https://example.com/avatar.png"
        )
        mockRepository.stubUserProfile = expectedProfile

        let result = try await sut.execute()

        XCTAssertEqual(result.userId, expectedProfile.userId)
        XCTAssertEqual(result.nickname, expectedProfile.nickname)
        XCTAssertEqual(result.email, expectedProfile.email)
        XCTAssertEqual(result.profileImageUrl, expectedProfile.profileImageUrl)
        XCTAssertEqual(mockRepository.getUserProfileCallCount, 1)
    }

    func test_프로필조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.getUserProfileError = MockUserError.failed

        do {
            _ = try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockUserError, .failed)
        }

        XCTAssertEqual(mockRepository.getUserProfileCallCount, 1)
    }
}
