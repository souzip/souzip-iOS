import XCTest
@testable import Domain

final class UserLoadUseCaseTests: XCTestCase {
    func test_프로필조회_리포지토리위임() async throws {
        let mock = MockUserRepository()
        let sut = DefaultLoadUserProfileUseCase(userRepo: mock)

        let result = try await sut.execute()

        XCTAssertEqual(result.userId, DomainTestFixtures.userProfile.userId)
        XCTAssertEqual(mock.getUserProfileCallCount, 1)
    }

    func test_내기념품목록_페이지전달() async throws {
        let mock = MockUserRepository()
        let sut = DefaultLoadUserSouvenirsUseCase(userRepo: mock)

        let result = try await sut.execute(page: 1, size: 20)

        XCTAssertEqual(result.items.count, 0)
        XCTAssertEqual(mock.getUserSouvenirsCallCount, 1)
        XCTAssertEqual(mock.lastSouvenirsPage, 1)
        XCTAssertEqual(mock.lastSouvenirsSize, 20)
    }
}
